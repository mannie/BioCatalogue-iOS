//
//  SearchViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_iPhone.h"


@implementation SearchViewController_iPhone

@synthesize navigationController;
@synthesize serviceDetailViewController, userDetailViewController, providerDetailViewController;
@synthesize paginationController;


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [UIView startLoadingAnimation:activityIndicator dimmingView:currentPageLabel];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [UIView stopLoadingAnimation:activityIndicator undimmingView:currentPageLabel];
} // stopLoadingAnimation

-(void) postFetchActions {
  [searchResults release];
  searchResults = [[searchResultsDocument objectForKey:JSONResultsElement] retain];
  
  currentPageLabel.hidden = NO;
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
  
  previousPageButton.hidden = currentPage == 1;
  nextPageBarButton.hidden = currentPage == lastPage;
  
  [self stopLoadingAnimation];
  performingSearch = NO;
  
  [myTableView reloadData];
} // postFetchActions

-(void) performSearch {
  [searchResultsScope release];
  searchResultsScope = [[NSString stringWithString:searchScope] retain];
  [paginationController performSearch:mySearchBar.text
                            withScope:searchResultsScope
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
  
  searchScope = ServicesSearchScope;
  
  currentPageLabel.hidden = YES;
  previousPageButton.hidden = YES;
  nextPageBarButton.hidden = YES;
  
  [self stopLoadingAnimation];
} // viewDidLoad

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self searchBarCancelButtonClicked:mySearchBar];
} // viewWillAppear

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (performingSearch || [searchResults count] == 0)
    return 1;
  else
    return [searchResults count];
} // tableView:numberOfRowsInSection

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  if (performingSearch || [searchResults count] == 0) {
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (performingSearch) {
      cell.detailTextLabel.text = @"Searching, Please Wait...";
    } else {
      NSString *searchQuery = [searchResultsDocument objectForKey:JSONSearchQueryElement];    
      cell.detailTextLabel.text = (searchResultsDocument == nil ?
                                   @"No search has been performed yet" : 
                                   [NSString stringWithFormat:@"No %@ containing '%@'", searchScope, searchQuery]);      
    }
    
    return cell;
  }
  
  id listing  = [searchResults objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [listing objectForKey:JSONNameElement];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  if (searchResultsScope == ServicesSearchScope) {
    cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:listing];
    
    NSURL *imageURL = [NSURL URLWithString:[[listing objectForKey:JSONLatestMonitoringStatusElement]
                                            objectForKey:JSONSmallSymbolElement]];
    cell.imageView.image = [UIImage imageNamed:[[imageURL lastPathComponent] stringByDeletingPathExtension]];    
  } else {
    cell.detailTextLabel.text = nil;
    
    if (searchResultsScope == UsersSearchScope) {
      cell.imageView.image = [UIImage imageNamed:UserIcon];
    } else {
      cell.imageView.image = [UIImage imageNamed:ProviderIcon];
    }
  }
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
  id detailViewController;
  
  if (searchResultsScope == ServicesSearchScope)
    detailViewController = serviceDetailViewController;
  else if (searchResultsScope == UsersSearchScope)
    detailViewController = userDetailViewController;
  else
    detailViewController = providerDetailViewController;
  
  [detailViewController loadView];
  
  if (searchResultsScope == ServicesSearchScope) {  
    [NSOperationQueue addToMainQueueSelector:@selector(updateWithProperties:) 
                                    toTarget:detailViewController
                                  withObject:[searchResults objectAtIndex:indexPath.row]];
  } else {
    [detailViewController updateWithProperties:[searchResults objectAtIndex:indexPath.row]];
  }
  
  [providerDetailViewController makeShowServicesButtonVisible:YES];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.navigationController pushViewController:detailViewController animated:YES];
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
  
  [self startLoadingAnimation];
  [NSOperationQueue addToMainQueueSelector:@selector(performSearch) toTarget:self withObject:nil];
  
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
  [previousPageButton release];
  [nextPageBarButton release];
  [currentPageLabel release];
  
  [mySearchBar release];
  [myTableView release];
  [activityIndicator release];
  
  [navigationController release];
  
  [serviceDetailViewController release];
  [userDetailViewController release];
  [providerDetailViewController release];
  
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
  
  [searchResultsDocument release];
  [searchResults release];
  
  [super dealloc];
} // dealloc


@end

