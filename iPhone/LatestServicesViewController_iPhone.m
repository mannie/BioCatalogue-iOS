//
//  LatestServicesViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LatestServicesViewController_iPhone.h"


@implementation LatestServicesViewController_iPhone

@synthesize detailViewController, navigationController;
@synthesize paginationController;


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [UIView startLoadingAnimation:activityIndicator dimmingView:currentPageLabel];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [UIView stopLoadingAnimation:activityIndicator undimmingView:currentPageLabel];
} // stopLoadingAnimation

-(void) postFetchActions {  
  [myTableView setTableHeaderView:nil];
  currentPageLabel.hidden = NO;
  
  [services release];
  services = [[servicesData objectForKey:JSONResultsElement] retain];
  
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
  
  previousPageButton.hidden = currentPage == 1;
  nextPageBarButton.hidden = currentPage == lastPage;
  
  [self stopLoadingAnimation];
  fetching = NO;

  [myTableView reloadData];
} // postFetchActions

-(void) performServiceFetch {
  [paginationController performServiceFetchForPage:&currentPage
                                          lastPage:&lastPage
                                          progress:&fetching
                                       resultsData:&servicesData
                                performingSelector:@selector(postFetchActions)
                                          onTarget:self];
} // performServiceFetch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  currentPageLabel.hidden = YES;
  previousPageButton.hidden = YES;
  nextPageBarButton.hidden = YES;

  [NSOperationQueue addToMainQueueSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (fetching) {
    return 1;
  } else {
    return [services count];
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
  id service = [services objectAtIndex:indexPath.row];
  
  cell.textLabel.text = [service objectForKey:JSONNameElement];
  cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:service];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  NSURL *imageURL = [NSURL URLWithString:
                     [[service objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
  cell.imageView.image = [UIImage imageNamed:[[imageURL lastPathComponent] stringByDeletingPathExtension]];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [NSOperationQueue addToMainQueueSelector:@selector(updateWithProperties:) 
                                  toTarget:detailViewController
                                withObject:[services objectAtIndex:indexPath.row]];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [previousPageButton release];
  [nextPageBarButton release];
  [currentPageLabel release];
  
  [myTableView release];
  [activityIndicator release];
  
  [detailViewController release];
  [navigationController release];
  
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
  
  [servicesData release];
  [services release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end

