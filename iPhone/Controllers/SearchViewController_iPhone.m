//
//  SearchViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_iPhone.h"


@implementation SearchViewController_iPhone

@synthesize serviceDetailViewController, userDetailViewController, providerDetailViewController;
@synthesize paginationController;


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [activityIndicator startAnimating];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [activityIndicator stopAnimating];
} // stopLoadingAnimation

-(void) postFetchActions {
  [searchResults release];
  searchResults = [[paginationController lastSearchResults] retain];
  
  [self stopLoadingAnimation];
  
  [myTableView reloadData];
} // postFetchActions

-(void) performSearch {
  [searchResults release];
  searchResults = [[NSArray array] retain];
  
  [activityIndicator performSelectorOnMainThread:@selector(startAnimating)
                                      withObject:nil
                                   waitUntilDone:NO];
  
  [paginationController performSearch:mySearchBar.text
                            withScope:searchScope
                                 page:1
                   performingSelector:@selector(postFetchActions)
                             onTarget:self];
  
  [paginationController updateSearchPaginationButtons];
} // performSearch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  searchScope = ServicesSearchScope;

  [activityIndicator stopAnimating];
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
  if ([searchResults count] == 0) {
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
    cell.detailTextLabel.text = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
  }
  
  id listing  = [searchResults objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [listing objectForKey:JSONNameElement];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  if ([[paginationController lastSearchScope] isEqualToString:ServicesSearchScope]) {
    cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:listing];
    
    NSURL *imageURL = [NSURL URLWithString:[[listing objectForKey:JSONLatestMonitoringStatusElement]
                                            objectForKey:JSONSmallSymbolElement]];
    cell.imageView.image = [UIImage imageNamed:[[imageURL lastPathComponent] stringByDeletingPathExtension]];    
  } else {
    cell.detailTextLabel.text = nil;
    
    if ([[paginationController lastSearchScope] isEqualToString:UsersSearchScope]) {
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
  
  if ([[paginationController lastSearchScope] isEqualToString:ServicesSearchScope]) {
    detailViewController = serviceDetailViewController;
  } else if ([[paginationController lastSearchScope] isEqualToString:UsersSearchScope]) {
    detailViewController = userDetailViewController;
  } else {
    detailViewController = providerDetailViewController;
  }
    
  if ([[paginationController lastSearchScope] isEqualToString:ServicesSearchScope]) {
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
  [mySearchBar release];
  [myTableView release];
  [activityIndicator release];
    
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
  
  [searchResults release];
  
  [super dealloc];
} // dealloc


@end

