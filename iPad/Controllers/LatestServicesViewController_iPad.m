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
  
  [[self tableView] reloadData];
} // postFetchActions

-(void) performServiceFetch {  
  [detailViewController startLoadingAnimation];
  [paginationController performServiceFetch:1 performingSelector:@selector(postFetchActions) onTarget:self];
  [paginationController updateServicePaginationButtons];
} // performServiceFetch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
  
  [NSOperationQueue addToNewQueueSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
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
  id service = [services objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [service objectForKey:JSONNameElement];
  cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:service];
  
  NSURL *imageURL = [NSURL URLWithString:[[service objectForKey:JSONLatestMonitoringStatusElement] 
                                          objectForKey:JSONSmallSymbolElement]];
  cell.imageView.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
  
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
  
  [detailViewController dismissAuxiliaryDetailPanel:self];
  
  NSDictionary *listing = [services objectAtIndex:indexPath.row];
  
  [detailViewController startLoadingAnimation];
  [NSOperationQueue addToNewQueueSelector:@selector(updateWithPropertiesForServicesScope:)
                                 toTarget:detailViewController
                               withObject:listing];
  
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

