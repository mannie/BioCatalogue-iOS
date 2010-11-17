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

-(void) performSearch {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  performingSearch = YES;
  [[self tableView] reloadData];
  
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
  
  currentPageLabel.hidden = lastPage == 1;
  
  performingSearch = NO;
  [[self tableView] reloadData];
  
  [autoreleasePool drain];
}


#pragma mark -
#pragma mark IBActions

-(IBAction) loadServicesOnNextPage:(id)sender {
  if ([searchResults count] > 0) {
    currentPage++;
  }
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
}

-(IBAction) loadServicesOnPreviousPage:(id)sender {
  if (currentPage > 1) {
    currentPage--;
  }
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  searchScope = ServicesSearchScope;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self searchBarCancelButtonClicked:mySearchBar];
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (performingSearch || [searchResults count] == 0) {
    return 1;
  } else {
    return [searchResults count];
  }
}


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
    cell.detailTextLabel.text = [[listing objectForKey:JSONTechnologyTypesElement] lastObject];
    
    NSURL *imageURL = [NSURL URLWithString:[[listing objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
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
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (performingSearch || [searchResults count] == 0) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    return;
  }
  
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
    NSThread *updateThread = [[NSThread alloc] initWithTarget:detailViewController
                                                     selector:@selector(updateWithProperties:)
                                                       object:[searchResults objectAtIndex:indexPath.row]];
    [updateThread start];
    [updateThread release];
  } else {
    [detailViewController updateWithProperties:[searchResults objectAtIndex:indexPath.row]];
  }
  
  [providerDetailViewController makeShowServicesButtonVisible:YES];
  
  [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark Search bar delegate

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:YES animated:YES];
  
  searchBar.showsScopeBar = YES;
  [searchBar sizeToFit];
  
  return YES;
}

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:NO animated:YES];
  
  searchBar.showsScopeBar = NO;  
  [searchBar sizeToFit];
  
  [searchBar resignFirstResponder];
  
  return YES;
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self searchBarShouldEndEditing:searchBar];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  currentPage = 1;
  [NSThread detachNewThreadSelector:@selector(performSearch) toTarget:self withObject:nil];
  //  [self performSelectorOnMainThread:@selector(performSearch) withObject:nil waitUntilDone:NO];
  
  [searchBar resignFirstResponder];
}

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
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [previousPageButton release];
  [nextPageBarButton release];
  [currentPageLabel release];
  
  [mySearchBar release];
  
  [navigationController release];
  
  [serviceDetailViewController release];
  [userDetailViewController release];
  [providerDetailViewController release];
}
- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [self releaseIBOutlets];
}


- (void)dealloc {
  [self releaseIBOutlets];
  
  [searchResultsDocument release];
  [searchResults release];
  
  [super dealloc];
}


@end

