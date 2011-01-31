//
//  LatestServicesViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 04/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LatestServicesViewController_iPad.h"
#import "DetailViewController_iPad.h"


@implementation LatestServicesViewController_iPad

@synthesize detailViewController, paginationController;


#pragma mark -
#pragma mark Private Helpers

-(void) postFetchActions {  
  [services release];
  services = [[paginationController lastFetchedServices] retain];
  
  [detailViewController stopLoadingAnimation];
  [paginationController updateServicePaginationButtons];    
  
  [[self tableView] reloadData];
} // postFetchActions


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
  
  [UIContentController setBrushedMetalBackground:self.tableView];
  
  [detailViewController startLoadingAnimation];
  [paginationController performServiceFetch:1 performingSelector:@selector(postFetchActions) onTarget:self];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [services count];
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
                               withProperties:[services objectAtIndex:indexPath.row]
                                   givenScope:ServiceResourceScope];
    
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([detailViewController isCurrentlyBusy]) {
    [tableView selectRowAtIndexPath:lastSelection animated:YES 
                     scrollPosition:UITableViewScrollPositionNone];
    return;
  }

  [detailViewController startLoadingAnimation];
  [detailViewController dismissAuxiliaryDetailPanel:self];
    
  dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
    [detailViewController updateWithPropertiesForServicesScope:[services objectAtIndex:indexPath.row]];
  });
  
  [lastSelection release];
  lastSelection = [indexPath retain];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [detailViewController release];
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
  [services release];
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end

