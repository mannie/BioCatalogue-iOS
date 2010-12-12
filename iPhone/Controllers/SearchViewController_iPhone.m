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
  
  [paginationController updateSearchPaginationButtons];      
  
  [[self tableView] reloadData];
} // postFetchActions


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  searchScope = ServiceResourceScope;
  
  [UIContentController setBrushedMetalBackground:self.tableView];
  
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
  [UIContentController customiseTableViewCell:cell
                               withProperties:[searchResults objectAtIndex:indexPath.row]
                                   givenScope:[paginationController lastSearchScope]];  
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
  id detailViewController;
  
  if ([[paginationController lastSearchScope] isEqualToString:ServiceResourceScope]) {
    detailViewController = serviceDetailViewController;
  } else if ([[paginationController lastSearchScope] isEqualToString:UserResourceScope]) {
    detailViewController = userDetailViewController;
  } else {
    detailViewController = providerDetailViewController;
  }
    
  if ([[paginationController lastSearchScope] isEqualToString:ServiceResourceScope]) {
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [detailViewController updateWithProperties:[searchResults objectAtIndex:indexPath.row]];
    });
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
  
  BOOL searchHasNotChanged = ([mySearchBar.text isEqualToString:[paginationController lastSearchQuery]] &&
                              [searchScope isEqualToString:[paginationController lastSearchScope]]);
  if (!searchHasNotChanged) {
    dispatch_async(dispatch_queue_create("Search", NULL), ^{
      [searchResults release];
      searchResults = [[NSArray array] retain];
      [[self tableView] reloadData];
      [[self tableView] setNeedsDisplay];
      
      [activityIndicator performSelectorOnMainThread:@selector(startAnimating)
                                          withObject:nil
                                       waitUntilDone:NO];
      
      [paginationController performSearch:mySearchBar.text
                                withScope:searchScope
                                     page:1
                       performingSelector:@selector(postFetchActions)
                                 onTarget:self];
    });
  }
  
  [searchBar resignFirstResponder];
} // searchBarSearchButtonClicked

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  if (selectedScope == ServiceResourceScopeIndex) {
    searchBar.placeholder = @"Search For A Service";
    searchScope = ServiceResourceScope;
  } else if (selectedScope == UserResourceScopeIndex) {
    searchBar.placeholder = @"Search For A User";
    searchScope = UserResourceScope;
  } else {
    searchBar.placeholder = @"Search For A Service Provider";
    searchScope = ProviderResourceScope;
  }
} // searchBar:selectedScopeButtonIndexDidChange


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {  
  [mySearchBar release];
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

