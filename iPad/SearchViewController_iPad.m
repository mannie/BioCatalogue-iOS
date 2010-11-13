//
//  SearchViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController_iPad.h"


@implementation SearchViewController_iPad

@synthesize detailViewController;


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
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (performingSearch || [searchResults count] == 0) {
    return 1;
  } else {
    return 3;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!performingSearch && section == MainSection) {
    return [searchResults count];
  } else {
    return 1;
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
    
    if (performingSearch) {
      cell.detailTextLabel.text = @"Searching, Please Wait...";
    } else {
      NSString *searchQuery = [searchResultsDocument objectForKey:JSONSearchQueryElement];
      cell.detailTextLabel.text = (searchResultsDocument == nil ?
                                   @"No search has been performed yet" : 
                                   [NSString stringWithFormat:@"No %@ containing '%@'", searchScope, searchQuery]);
      
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
            
    return cell;
  }

  if (indexPath.section == MainSection) {
    id listing  = [searchResults objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [listing objectForKey:JSONNameElement];
    
    if (searchResultsScope == ServicesSearchScope) {
      cell.detailTextLabel.text = [[listing objectForKey:JSONTechnologyTypesElement] lastObject];
      
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
    int lastPage = [[searchResultsDocument objectForKey:JSONPagesElement] intValue];
    currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
    
    cell.imageView.image = nil;
    
    if (indexPath.section == PreviousPageButtonSection) {
      if (currentPage == 1) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } else {
      if (currentPage == lastPage) { 
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } // if else previous page button
  } // if else main section
  
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

  if (indexPath.section == MainSection) {
    detailViewController.detailItem = [[searchResults objectAtIndex:indexPath.row] objectForKey:JSONNameElement];
    
    if (searchResultsScope == ServicesSearchScope) {
    } else if (searchResultsScope == UsersSearchScope) {
    } else {
    }
  } else {
    if (indexPath.section == PreviousPageButtonSection && currentPage != 1) {
      [self loadServicesOnPreviousPage:self];
    } 
    
    int lastPage = [[searchResultsDocument objectForKey:JSONPagesElement] intValue];    
    if (indexPath.section == NextPageButtonSection && currentPage != lastPage) {
      [self loadServicesOnNextPage:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
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

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [detailViewController release];
  
  [super dealloc];
}


@end

