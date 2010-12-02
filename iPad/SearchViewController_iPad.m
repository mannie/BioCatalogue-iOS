//
//  SearchViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_iPad.h"


@implementation SearchViewController_iPad

@synthesize detailViewController, paginationController;


#pragma mark -
#pragma mark Private Helpers

-(void) postFetchActions {
  [searchResults release];
  searchResults = [[searchResultsDocument objectForKey:JSONResultsElement] retain];
  
  currentPageLabel.text = (lastPage == 0 ? @"" : [NSString stringWithFormat:@"%i of %i", currentPage, lastPage]);
  
  performingSearch = NO;
  [[self tableView] reloadData];
  [detailViewController stopLoadingAnimation];
} // postFetchActions

-(void) performSearch {
  searchResultsScope = searchScope;
  [paginationController performSearch:mySearchBar.text
                            withScope:searchScope
                              forPage:&currentPage
                             lastPage:&lastPage
                             progress:&performingSearch
                          resultsData:&searchResultsDocument
                   performingSelector:@selector(postFetchActions)
                             onTarget:self];
} // performSearch
 

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self searchBarCancelButtonClicked:mySearchBar];

  searchScope = ServicesSearchScope;
  currentPageLabel.text = @"";
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (performingSearch || [searchResults count] == 0) {
    return 1;
  } else {
    return 3;
  }
} // numberOfSectionsInTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!performingSearch && section == MainSection) {
    return [searchResults count];
  } else {
    return 1;
  }
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  if (performingSearch || [searchResults count] == 0) {
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (performingSearch) {
      cell.detailTextLabel.text = @"Searching, Please Wait...";
    } else {
      NSString *searchQuery = [searchResultsDocument objectForKey:JSONSearchQueryElement];
      cell.detailTextLabel.text = (searchResults == nil ?
                                   @"No search has been performed yet" : 
                                   [NSString stringWithFormat:@"No %@ containing '%@'", searchScope, searchQuery]);
    }
    
    return cell;
  }
  
  if (indexPath.section == MainSection) {
    id listing  = [searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [listing objectForKey:JSONNameElement];
    
    if (searchResultsScope == ServicesSearchScope) {
      cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:listing];
      
      NSURL *imageURL = [NSURL URLWithString:[[listing objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
      cell.imageView.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
    } else {
      cell.detailTextLabel.text = nil;
      
      if (searchResultsScope == UsersSearchScope) {
        cell.imageView.image = [UIImage imageNamed:UserIconFull];
      } else {
        cell.imageView.image = [UIImage imageNamed:ProviderIconFull];
      }
    }
  } else {    
    cell.imageView.image = nil;
    
    if (indexPath.section == PreviousPageButtonSection) {
      if (currentPage == 1) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Show Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Show Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } else {
      if (currentPage == lastPage) { 
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Show Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Show Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } // if else previous page button
  } // if else main section
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [detailViewController dismissAuxiliaryDetailPanel:self];
  
  if (indexPath.section == MainSection) {    
    NSDictionary *listing = [searchResults objectAtIndex:indexPath.row];
    
    if (searchResultsScope == ServicesSearchScope) {
      [NSOperationQueue addToCurrentQueueSelector:@selector(startLoadingAnimation)
                                         toTarget:detailViewController
                                       withObject:nil];
      [NSOperationQueue addToMainQueueSelector:@selector(updateWithPropertiesForServicesScope:)
                                      toTarget:detailViewController
                                    withObject:listing];
      [NSOperationQueue addToCurrentQueueSelector:@selector(setDescription:)
                                         toTarget:detailViewController
                                       withObject:[listing objectForKey:JSONDescriptionElement]];
    } else if (searchResultsScope == UsersSearchScope) {
      [detailViewController updateWithPropertiesForUsersScope:listing];
    } else {
      [detailViewController updateWithPropertiesForProvidersScope:listing];
    }
  } else {
    if (indexPath.section == PreviousPageButtonSection && currentPage != 1) {
      [detailViewController startLoadingAnimation];
      [NSOperationQueue addToNewQueueSelector:@selector(loadSearchResultsForPreviousPage)
                                      toTarget:paginationController
                                    withObject:nil];
    } 
    
    if (indexPath.section == NextPageButtonSection && currentPage != lastPage) {
      [detailViewController startLoadingAnimation];
      [NSOperationQueue addToNewQueueSelector:@selector(loadSearchResultsForNextPage) 
                                      toTarget:paginationController 
                                    withObject:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Search bar delegate

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:YES animated:YES];
  
  searchBar.showsScopeBar = YES;
  [searchBar sizeToFit];
  
  return YES;
} // searchBarShouldBeginEditing

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:NO animated:YES];
  
  searchBar.showsScopeBar = NO;  
  [searchBar sizeToFit];
  
  [searchBar resignFirstResponder];
  
  return YES;
} // searchBarShouldEndEditing

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self searchBarShouldEndEditing:searchBar];
} // searchBarCancelButtonClicked

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  currentPage = 1;

  [detailViewController startLoadingAnimation];
  [self searchBarShouldEndEditing:mySearchBar];
  
  [NSOperationQueue addToNewQueueSelector:@selector(performSearch) toTarget:self withObject:nil];
  
  [searchBar resignFirstResponder];
} // searchBarSearchButtonClicked

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  if (selectedScope == ServicesSearchScopeIndex) {
    searchBar.placeholder = @"Search For A Service";
    searchScope = ServicesSearchScope;
  } else if (selectedScope == UsersSearchScopeIndex) {
    searchBar.placeholder = @"Search For A User";
    searchScope = UsersSearchScope;
  } else {
    searchBar.placeholder = @"Search For A Service Provider";
    searchScope = ProvidersSearchScope;
  }
} // searchBar:selectedScopeButtonIndexDidChange


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [currentPageLabel release];
  [mySearchBar release];
  [detailViewController release];
  [paginationController release];
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  [super dealloc];
} // dealloc


@end

