//
//  BrowseByProviderViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseByProviderViewController.h"


@implementation BrowseByProviderViewController

@synthesize providerDetailViewController;


-(void) loadItemsOnNextPage {
  if (lastLoadedPage == lastPage) {
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    activeFetchThreads--;
    return;
  }
  
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    lastLoadedPage++;
    int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads
    
    NSDictionary *document = [[BioCatalogueClient providers:ItemsPerPage page:pageToLoad] retain];
    if (document) {
      [paginatedProviders setObject:[document objectForKey:JSONResultsElement]
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
  
  [self refreshTableViewDataSource];
}


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  [paginatedProviders release];
  paginatedProviders = [[NSMutableDictionary alloc] init];
  
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
  return [[paginatedProviders objectForKey:[NSNumber numberWithInt:section]] count];
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
      if (activeFetchThreads < 3) {
        activeFetchThreads++;
        [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
        [self loadItemsOnNextPage];
      }
    } @catch (NSException * e) {
      [e log];
    }    
  }
  
  NSArray *itemsInSection = [paginatedProviders objectForKey:[NSNumber numberWithInt:[indexPath section]]];  
  [UIContentController customiseTableViewCell:cell 
                               withProperties:[itemsInSection objectAtIndex:indexPath.row]
                                   givenScope:ProviderResourceScope];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsInSection = [paginatedProviders objectForKey:[NSNumber numberWithInt:[indexPath section]]];
  
  [providerDetailViewController loadView];
  [providerDetailViewController updateWithProperties:[itemsInSection objectAtIndex:indexPath.row]];
  [providerDetailViewController makeShowServicesButtonVisible:YES];

  [self.navigationController pushViewController:providerDetailViewController animated:YES];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} //tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [providerDetailViewController release];
  
  [activityIndicator release];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [paginatedProviders release];
  
  [super dealloc];
}


@end

