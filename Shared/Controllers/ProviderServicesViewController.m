//
//  ProviderServicesViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProviderServicesViewController.h"


@implementation ProviderServicesViewController

@synthesize iPhoneDetailViewController;


#pragma mark -
#pragma mark Helpers

-(void) updateTableViewFooterView {
  NSNumber *shouldHide = [NSNumber numberWithBool:([[paginatedServices objectForKey:[NSNumber numberWithInt:0]] count] != 0)];
  [noServicesLabel performSelectorOnMainThread:@selector(setHidden:) withObject:shouldHide waitUntilDone:NO];
  
  if (activeFetchThreads == 0) {
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
  }
}

-(void) loadItemsOnNextPage {
  if (lastLoadedPage == lastPage) {
    activeFetchThreads--;
    [self updateTableViewFooterView];
    return;
  }
  
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    lastLoadedPage++;
    int pageToLoad = lastLoadedPage; // use local var to reduce contention when loading in multiple threads
    
    NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:pageToLoad providerID:currentProviderID] retain];
    if (document) {
      [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                            forKey:[NSNumber numberWithInt:pageToLoad-1]];
      
      lastPage = [[document objectForKey:JSONPagesElement] intValue];
      
      [document release];      
    }
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    activeFetchThreads--;
    
    [self updateTableViewFooterView];    
  });
} // loadItemsOnNextPage

-(void) refreshTableViewDataSource {
  [activityIndicator startAnimating];
  
  [paginatedServices release];
  paginatedServices = [[NSMutableDictionary alloc] init];
  
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  
  lastLoadedPage = 0;
  lastPage = 1;
  
  activeFetchThreads++;
  [self loadItemsOnNextPage];
} // refreshTableViewDataSource

-(void) updateWithServicesFromProviderWithID:(NSUInteger)providerID {
  currentProviderID = providerID;
  dispatch_async(dispatch_queue_create("Load provider services", NULL), ^{
    [self refreshTableViewDataSource];
  });
  
  if ([[UIDevice currentDevice] isIPadDevice]) {
    if (!iPadDetailViewController) {
      AppDelegate_iPad *delegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
      for (UIViewController *viewController in [[delegate splitViewController] viewControllers]) {
        if ([viewController isMemberOfClass:[DetailViewController_iPad class]]) {
          iPadDetailViewController = [viewController retain];
          break;
        }
      }      
    }
  } else {
    [iPhoneDetailViewController loadView];
  }
} // updateWithServicesFromProviderWithID


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [UIContentController setTableViewBackground:self.tableView];
  noServicesLabel.hidden = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


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
} // tableView:titleForHeaderInSection

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
    if ([iPadDetailViewController isCurrentlyBusy] && lastSelectedIndexIPad) {
      [tableView selectRowAtIndexPath:lastSelectedIndexIPad animated:YES 
                       scrollPosition:UITableViewScrollPositionMiddle];
      return;
    }
    
    [iPadDetailViewController startLoadingAnimation];
    
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPadDetailViewController updateWithPropertiesForServicesScope:[itemsInSection objectAtIndex:indexPath.row]];
    });
    
    [lastSelectedIndexIPad release];
    lastSelectedIndexIPad = [indexPath retain];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  } else {
    [iPhoneDetailViewController makeShowProvidersButtonVisible:NO];
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
  
  [activityIndicator release];
  [noServicesLabel release];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [paginatedServices release];
  
  [super dealloc];
} // dealloc


@end

