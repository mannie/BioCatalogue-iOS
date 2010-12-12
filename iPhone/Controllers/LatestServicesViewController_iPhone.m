//
//  LatestServicesViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LatestServicesViewController_iPhone.h"


@implementation LatestServicesViewController_iPhone

@synthesize detailViewController, paginationController;


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [activityIndicator startAnimating];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [activityIndicator stopAnimating];
} // stopLoadingAnimation

-(void) postFetchActions {  
  [services release];
  services = [[paginationController lastFetchedServices] retain];
  
  [self stopLoadingAnimation];
  [paginationController updateServicePaginationButtons];

  [[self tableView] reloadData];
} // postFetchActions

-(void) performServiceFetch {
} // performServiceFetch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController setBrushedMetalBackground:self.tableView];
  
  dispatch_async(dispatch_queue_create("Fetch services", NULL), ^{
    [paginationController performServiceFetch:1 performingSelector:@selector(postFetchActions) onTarget:self];
  });
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
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
    [detailViewController updateWithProperties:[services objectAtIndex:indexPath.row]];
  });
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [activityIndicator release];
  
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
} // viewDidLoad

- (void)dealloc {
  [services release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end

