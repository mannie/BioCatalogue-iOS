//
//  BrowseByDateViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation BrowseByDateViewController

@synthesize iPhoneDetailViewController, iPadDetailViewController;


-(void) loadItemsOnNextPage {
  if (lastLoadedPage == lastPage) {
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    activeFetchThreads--;
    return;
  }
  
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    lastLoadedPage++;
    int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads

    NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:pageToLoad] retain];
    if (document) {
      [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                            forKey:[NSNumber numberWithInt:pageToLoad-1]];
      
      lastPage = [[document objectForKey:JSONPagesElement] intValue];
      
      [document release];      
    }
        
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    activeFetchThreads--;
    if (activeFetchThreads == 0) {
      [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    }
  });
} // loadItemsOnNextPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
      
  dispatch_async(dispatch_queue_create("Load content", NULL), ^{
    [self refreshTableViewDataSource];
  });
  
  if (![iPhoneDetailViewController view]) [iPhoneDetailViewController loadView];
}


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  [paginatedServices release];
  paginatedServices = [[NSMutableDictionary alloc] init];
  
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  
  lastLoadedPage = 0;
  lastPage = 1;
  
  activeFetchThreads++;
  [self loadItemsOnNextPage];
} // refreshTableViewDataSource


#pragma mark -
#pragma mark Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section < lastPage) {
    return [NSString stringWithFormat:@"Page %i of %i", section + 1, lastPage];
  } else {
    return nil;
  }
} // tableView:titleForHeaderInSection

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
    cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellXIB owner:self options:nil] lastObject];
  }
  
  // Configure the cell...
  if ([indexPath section] == lastLoadedPage - 1 && [indexPath row] >= AutoLoadTrigger) {
    // indexPath is in the last section
    @try {
      if (activeFetchThreads < 3) {
        activeFetchThreads++;
        [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
        [self loadItemsOnNextPage];
      }
    } @catch (NSException * e) {
      [e log];
    }    
  }
  
  NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];  
  [UIContentController populateTableViewCell:cell 
                               withObject:[itemsInSection objectAtIndex:[indexPath row]]
                                   givenScope:ServiceResourceScope];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];

  if ([[UIDevice currentDevice] isIPadDevice]) {
    if ([iPadDetailViewController isCurrentlyBusy] && lastSelectedIndexIPad) {
      [tableView selectRowAtIndexPath:lastSelectedIndexIPad animated:YES 
                       scrollPosition:UITableViewScrollPositionMiddle];
      return;
    }
    
    [iPadDetailViewController startLoadingAnimation];
    
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPadDetailViewController updateWithPropertiesForServicesScope:[itemsInSection objectAtIndex:[indexPath row]]];
    });
    
    [lastSelectedIndexIPad release];
    lastSelectedIndexIPad = [indexPath retain];

    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  } else {
    if (![iPhoneDetailViewController view]) [iPhoneDetailViewController loadView];
    [iPhoneDetailViewController makeShowProvidersButtonVisible:YES];
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPhoneDetailViewController updateWithProperties:[itemsInSection objectAtIndex:[indexPath row]]];
    });
    [[self navigationController] pushViewController:iPhoneDetailViewController animated:YES];

    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  } // if else ipad
} //tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [iPhoneDetailViewController release];
  [iPadDetailViewController release];

  [activityIndicator release];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [paginatedServices release];
  
  [super dealloc];
} // dealloc


@end

