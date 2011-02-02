//
//  BrowseByDateViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseByDateViewController.h"


@implementation BrowseByDateViewController

@synthesize iPhoneDetailViewController, iPadDetailViewController;


-(void) loadItemsOnNextPage {
  if (lastLoadedPage == lastPage) return;
  
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    activeFetchThreads++;
    
    lastLoadedPage++;
    int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads

    NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:pageToLoad] retain];
    [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                          forKey:[NSNumber numberWithInt:pageToLoad-1]];

    [document release];
    
    [[self tableView] reloadData];
    
    activeFetchThreads--;
  });
} // loadItemsOnNextPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController setTableViewBackground:self.tableView];
    
  [self refreshTableViewDataSource];
}


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  [paginatedServices release];
  paginatedServices = [[NSMutableDictionary alloc] init];
  
  [[self tableView] reloadData];
  
  lastLoadedPage = 1;
  int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads
  
  NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:pageToLoad] retain];
  [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                        forKey:[NSNumber numberWithInt:pageToLoad-1]];

  lastPage = [[document objectForKey:JSONPagesElement] intValue];
  
  [document release];

  [[self tableView] reloadData];
}


#pragma mark -
#pragma mark Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section < lastPage) {
    return [NSString stringWithFormat:@"Page %i", section + 1];
  } else {
    return nil;
  }
} // tableView:titleForHeaderInSection

-(NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  if (section == lastLoadedPage - 1 && activeFetchThreads > 0) {
    return DefaultLoadingText;
  } else {
    return nil;
  }
} // tableView:titleForFooterInSection

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return lastLoadedPage;
} // numberOfSectionsInTableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[paginatedServices objectForKey:[NSNumber numberWithInt:section]] count];
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  if ([indexPath section] == lastLoadedPage - 1 && [indexPath row] >= AutoLoadTrigger) {
    // indexPath is in the last section
    @try {
      [self loadItemsOnNextPage];
    } @catch (NSException * e) {
      [e log];
    }    
  }
  
  NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];  
  [UIContentController customiseTableViewCell:cell 
                               withProperties:[itemsInSection objectAtIndex:indexPath.row]
                                   givenScope:ServiceResourceScope];
    
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];

  if ([[UIDevice currentDevice] isIPadDevice]) {
    if ([iPadDetailViewController isCurrentlyBusy]) {
      [tableView selectRowAtIndexPath:lastSelectedIndexIPad animated:YES 
                       scrollPosition:UITableViewScrollPositionNone];
      return;
    }
    
    [iPadDetailViewController startLoadingAnimation];
    [iPadDetailViewController dismissAuxiliaryDetailPanel:self];
    
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPadDetailViewController updateWithPropertiesForServicesScope:[itemsInSection objectAtIndex:indexPath.row]];
    });
    
    [lastSelectedIndexIPad release];
    lastSelectedIndexIPad = [indexPath retain];    
  } else {
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPhoneDetailViewController updateWithProperties:[itemsInSection objectAtIndex:indexPath.row]];
    });
    [self.navigationController pushViewController:iPhoneDetailViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  } // if else ipad
} //tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [iPhoneDetailViewController release];
  [iPadDetailViewController release];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [self releaseIBOutlets];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [paginatedServices release];
  
  [super dealloc];
}


@end

