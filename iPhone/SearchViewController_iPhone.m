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


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [UIView startAnimatingActivityIndicator:activityIndicator
                             dimmingViews:[NSArray arrayWithObject:currentPageLabel]];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [UIView stopAnimatingActivityIndicator:activityIndicator
                          undimmingViews:[NSArray arrayWithObject:currentPageLabel]];
} // stopLoadingAnimation

-(void) performSearch {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  performingSearch = YES;
  [myTableView reloadData];
  
  [searchResultsDocument release];
  searchResultsDocument = [[[BioCatalogueClient client] performSearch:mySearchBar.text 
                                                            withScope:searchScope
                                                   withRepresentation:JSONFormat
                                                                 page:currentPage] copy];
  
  [searchResults release];
  searchResults = [[searchResultsDocument objectForKey:JSONResultsElement] copy];
  
  searchResultsScope = searchScope;
  
  int servicesOnLastPage = [[searchResultsDocument objectForKey:JSONTotalElement] intValue] % ServicesPerPage;
  int lastPage = [[searchResultsDocument objectForKey:JSONPagesElement] intValue];
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
  
  previousPageButton.hidden = currentPage == 1;
  if ([searchResults count] == 0) {
    nextPageBarButton.hidden = YES;
  } else {
    nextPageBarButton.hidden = servicesOnLastPage < ServicesPerPage && currentPage == lastPage;
  }
  
  currentPageLabel.hidden = lastPage == 0;
  
  performingSearch = NO;
  [myTableView reloadData];
  
  [self stopLoadingAnimation];
  
  [autoreleasePool drain];
} // performSearch


#pragma mark -
#pragma mark IBActions

-(IBAction) loadServicesOnNextPage:(id)sender {
  if ([searchResults count] > 0) {
    currentPage++;
  }
  searchScope = searchResultsScope;
  [self startLoadingAnimation];
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
} // loadServicesOnNextPage

-(IBAction) loadServicesOnPreviousPage:(id)sender {
  if (currentPage > 1) {
    currentPage--;
  }
  searchScope = searchResultsScope;
  [self startLoadingAnimation];
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
} // loadServicesOnPreviousPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  searchScope = ServicesSearchScope;

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
  if (performingSearch || [searchResults count] == 0) {
    return 1;
  } else {
    return [searchResults count];
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
  
  if (searchResultsScope == ServicesSearchScope) {
    detailViewController = serviceDetailViewController;
  } else if (searchResultsScope == UsersSearchScope) {
    detailViewController = userDetailViewController;
  } else {
    detailViewController = providerDetailViewController;
  }
  
  [detailViewController loadView];
  
  if (searchResultsScope == ServicesSearchScope) {  
    // FIXME: threading issues
    [detailViewController updateWithProperties:[searchResults objectAtIndex:indexPath.row]];
//    [NSThread detachNewThreadSelector:@selector(updateWithProperties:) 
//                             toTarget:detailViewController
//                           withObject:[searchResults objectAtIndex:indexPath.row]];
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
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
  
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

