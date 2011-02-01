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


-(BOOL) indexPathIsLastElementInList:(NSIndexPath *)indexPath {
  NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];

  BOOL isLastSection = [indexPath section] == [[paginatedServices allKeys] count] - 1;
  BOOL isLastRow = [indexPath row] == [itemsInSection count];
  
  return isLastSection && isLastRow;
}


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
  
  NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:1] retain];
  lastPage = [[document objectForKey:JSONPagesElement] intValue];
  
  lastLoadedPage = 0;
  [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                        forKey:[NSNumber numberWithInt:lastLoadedPage]];
  lastLoadedPage++;
  
  [document release];
}


#pragma mark -
#pragma mark Table view data source

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [NSString stringWithFormat:@"Page %i", section + 1];
} // tableView:titleForHeaderInSection

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return lastLoadedPage;
} // numberOfSectionsInTableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int count = [[paginatedServices objectForKey:[NSNumber numberWithInt:section]] count];
  if (section == [[paginatedServices allKeys] count] - 1) {
    return count + 1;
  } else {
    return count;
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
  if ([self indexPathIsLastElementInList:indexPath]) {
    cell.detailTextLabel.text = LoadMoreItemsText;
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
  } else {
    NSArray *itemsInSection = [paginatedServices objectForKey:[NSNumber numberWithInt:[indexPath section]]];
    [UIContentController customiseTableViewCell:cell 
                                 withProperties:[itemsInSection objectAtIndex:indexPath.row]
                                     givenScope:ServiceResourceScope];
  }
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self indexPathIsLastElementInList:indexPath]) {
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:lastLoadedPage+1] retain];
      [paginatedServices setObject:[document objectForKey:JSONResultsElement]
                            forKey:[NSNumber numberWithInt:lastLoadedPage]];
      lastLoadedPage++;
      
      [document release];
      
      [[self tableView] reloadData];
    });
  } else {
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
  } // display info in detail view controllers
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

