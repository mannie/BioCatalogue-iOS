//
//  SearchViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation SearchViewController

@synthesize serviceDetailViewController, userDetailViewController, providerDetailViewController;
@synthesize iPadDetailViewController;


-(void) loadItemsOnNextPage {
  if (lastLoadedPage == lastPage) {
    [[emptyResultsCell detailTextLabel] performSelectorOnMainThread:@selector(setText:) withObject:nil waitUntilDone:YES];
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    activeFetchThreads--;
    return;
  }
    
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    lastLoadedPage++;
    int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads
    
    NSDictionary *document = [[BioCatalogueClient performSearch:lastSearchQuery
                                                      withScope:lastSearchScope
                                             withRepresentation:JSONFormat
                                                           page:pageToLoad] retain];

    if (document) {
      [paginatedSearchResults setObject:[document objectForKey:JSONResultsElement]
                                 forKey:[NSNumber numberWithInt:pageToLoad-1]];
      lastPage = [[document objectForKey:JSONPagesElement] intValue];
      
      [noSearchResultsLabel performSelectorOnMainThread:@selector(setHidden:)
                                             withObject:[NSNumber numberWithBool:([[document objectForKey:JSONResultsElement] count] > 0)]
                                          waitUntilDone:NO];
    } else {
      [noSearchResultsLabel performSelectorOnMainThread:@selector(setHidden:)
                                             withObject:[NSNumber numberWithBool:NO]
                                          waitUntilDone:NO];
    }
    
    [document release];
    
    [dataTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    activeFetchThreads--;
    if (activeFetchThreads == 0) {
      [[emptyResultsCell detailTextLabel] performSelectorOnMainThread:@selector(setText:) withObject:nil waitUntilDone:YES];
      [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    }
  });
} // loadItemsOnNextPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  emptyResultsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
  [[emptyResultsCell textLabel] setText:nil];
  [[emptyResultsCell detailTextLabel] setText:DefaultLoadingText];
  [[emptyResultsCell imageView] setImage:nil];
  [emptyResultsCell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [UIContentController customiseTableViewCell:emptyResultsCell];  

  [UIContentController customiseTableView:dataTableView];
  [UIContentController customiseTableView:[self tableView]];
  
  currentSearchScope = ServiceResourceScope;
  
  [noSearchResultsLabel setHidden:YES];
  
  [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
  
  dispatch_async(dispatch_queue_create("Load content", NULL), ^{
    [self refreshTableViewDataSource];
  });
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self searchBarCancelButtonClicked:mySearchBar];
} // viewWillAppear


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  if (!lastSearchQuery) return;
  
  [self performSelectorOnMainThread:@selector(searchBarShouldEndEditing:) withObject:mySearchBar waitUntilDone:NO];
    
  [mySearchBar performSelectorOnMainThread:@selector(setText:) withObject:lastSearchQuery waitUntilDone:NO];
  lastSearchScope = currentSearchScope;

  [paginatedSearchResults release];
  paginatedSearchResults = [[NSMutableDictionary alloc] init];
  
  [dataTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

  lastLoadedPage = 0;
  lastPage = 1;
  
  activeFetchThreads++;
  [self loadItemsOnNextPage];
} // refreshTableViewDataSource


#pragma mark -
#pragma mark Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (tableView != dataTableView) return nil;
  
  if (section < lastPage) {
    return [NSString stringWithFormat:@"Page %i of %i", section + 1, lastPage];
  } else {
    return nil;
  }
} // tableView:titleForHeaderInSection

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView != dataTableView) return 0;
  return lastLoadedPage;
} // numberOfSectionsInTableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView != dataTableView) return 0;

  NSArray *itemsInSection = [paginatedSearchResults objectForKey:[NSNumber numberWithInt:section]];
  if (lastLoadedPage == 1 && [itemsInSection count] == 0 && activeFetchThreads == 0) return 1;
  
  return [[paginatedSearchResults objectForKey:[NSNumber numberWithInt:section]] count];
} // tableView:numberOfRowsInSection

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView != dataTableView) return nil;
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellXIB owner:self options:nil] lastObject];
  }
  
  // Configure the cell...
  if ([indexPath section] == lastLoadedPage - 1 && [indexPath row] >= AutoLoadTrigger) {
    // indexPath is in the last section
    @try {
      if (activeFetchThreads < 3) {
        activeFetchThreads++;
        [[emptyResultsCell detailTextLabel] performSelectorOnMainThread:@selector(setText:) withObject:DefaultLoadingText waitUntilDone:YES];
        [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
        [self loadItemsOnNextPage];
      }
    } @catch (NSException * e) {
      [e log];
    }    
  }
  
  NSArray *itemsInSection = [paginatedSearchResults objectForKey:[NSNumber numberWithInt:[indexPath section]]];
  if (lastLoadedPage == 1 && [itemsInSection count] == 0 && activeFetchThreads == 0) {
    [[emptyResultsCell detailTextLabel] setText:[NSString stringWithFormat:@"No %@ found matching '%@'", lastSearchScope, lastSearchQuery]];
    return emptyResultsCell;
  }
  
  [UIContentController populateTableViewCell:cell 
                                  withObject:[itemsInSection objectAtIndex:[indexPath row]]
                                  givenScope:lastSearchScope];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView != dataTableView) return;
  
  NSArray *itemsInSection = [paginatedSearchResults objectForKey:[NSNumber numberWithInt:[indexPath section]]];
  if (lastLoadedPage == 1 && [itemsInSection count] == 0) return;
  
  if ([[UIDevice currentDevice] isIPadDevice]) {
    if (![lastSearchScope isEqualToString:ProviderResourceScope]) {
      if ([iPadDetailViewController isCurrentlyBusy] && lastSelectedIndexIPad) {
        [tableView selectRowAtIndexPath:lastSelectedIndexIPad animated:YES 
                         scrollPosition:UITableViewScrollPositionMiddle];
        return;
      }
      
      [iPadDetailViewController startLoadingAnimation];
      
      [lastSelectedIndexIPad release];
      lastSelectedIndexIPad = [indexPath retain];
      
      [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    if ([lastSearchScope isEqualToString:ServiceResourceScope]) {
      dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
        [iPadDetailViewController updateWithPropertiesForServicesScope:[itemsInSection objectAtIndex:[indexPath row]]];
      });
    } else if ([lastSearchScope isEqualToString:UserResourceScope]) {
      [iPadDetailViewController updateWithPropertiesForUsersScope:[itemsInSection objectAtIndex:[indexPath row]]];
    } else {
      if (![providerDetailViewController view]) [providerDetailViewController loadView];
      [providerDetailViewController updateWithProperties:[itemsInSection objectAtIndex:[indexPath row]]];      
      
      [providerDetailViewController showServicesButtonIfGreater:0];
      
      [[self navigationController] pushViewController:providerDetailViewController animated:YES];

      [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  } else {
    id iPhoneDetailViewController;
    if ([lastSearchScope isEqualToString:ServiceResourceScope]) {
      [serviceDetailViewController makeShowProvidersButtonVisible:YES];
      dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
        [serviceDetailViewController updateWithProperties:[itemsInSection objectAtIndex:[indexPath row]]];
      });
      iPhoneDetailViewController = serviceDetailViewController;
    } else {
      if ([lastSearchScope isEqualToString:UserResourceScope]) {
        iPhoneDetailViewController = userDetailViewController;
      } else {
        iPhoneDetailViewController = providerDetailViewController;
      }        
      
      if (![iPhoneDetailViewController view]) [iPhoneDetailViewController loadView];
      [iPhoneDetailViewController updateWithProperties:[itemsInSection objectAtIndex:[indexPath row]]];      

      [providerDetailViewController showServicesButtonIfGreater:0];
    }
    
    [[self navigationController] pushViewController:iPhoneDetailViewController animated:YES];

    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  } // if else ipad
} //tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Search bar delegate

-(BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:YES animated:YES];  
  return YES;
} // searchBarShouldBeginEditing

-(BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar {
  [searchBar setShowsCancelButton:NO animated:YES];
  [searchBar resignFirstResponder];
  
  return YES;
} // searchBarShouldEndEditing

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self searchBarShouldEndEditing:searchBar];
} // searchBarCancelButtonClicked

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self searchBarShouldEndEditing:mySearchBar];
  
  dispatch_async(dispatch_queue_create("Search", NULL), ^{      
    [lastSearchQuery release];
    lastSearchQuery = [[mySearchBar text] retain];
    lastSearchScope = currentSearchScope;
    
    [self refreshTableViewDataSource];
  });
  
  [searchBar resignFirstResponder];
} // searchBarSearchButtonClicked

-(void) searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  if (selectedScope == ServiceResourceScopeIndex) {
    [searchBar setPlaceholder:@"Search For A Service"];
    currentSearchScope = ServiceResourceScope;
  } else if (selectedScope == UserResourceScopeIndex) {
    [searchBar setPlaceholder:@"Search For A User"];
    currentSearchScope = UserResourceScope;
  } else {
    [searchBar setPlaceholder:@"Search For A Service Provider"];
    currentSearchScope = ProviderResourceScope;
  }
} // searchBar:selectedScopeButtonIndexDidChange


#pragma mark -
#pragma mark Memory management

-(void) viewDidUnload {
  [emptyResultsCell release];
  [super viewDidUnload];
}

-(void) releaseIBOutlets {
  [dataTableView release];
  
  [mySearchBar release];
  [iPadDetailViewController release];
  
  [serviceDetailViewController release];
  [userDetailViewController release];
  [providerDetailViewController release];

  [noSearchResultsLabel release];
  [activityIndicator release];
}

- (void)dealloc {
  [self releaseIBOutlets];
  
  [lastSearchQuery release];
  [paginatedSearchResults release];
  
  [super dealloc];
}


@end

