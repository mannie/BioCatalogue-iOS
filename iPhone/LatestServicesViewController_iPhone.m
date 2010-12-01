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
@synthesize paginationDelegate;


#pragma mark -
#pragma mark Helpers

-(void) startLoadingAnimation {
  [UIView startAnimatingActivityIndicator:activityIndicator
                             dimmingViews:[NSArray arrayWithObject:currentPageLabel]];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [UIView stopAnimatingActivityIndicator:activityIndicator 
                          undimmingViews:[NSArray arrayWithObject:currentPageLabel]];
} // stopLoadingAnimation

-(void) postFetchActions {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  [myTableView setTableHeaderView:nil];
  currentPageLabel.hidden = NO;
  
  [services release];
  services = [[servicesData objectForKey:JSONResultsElement] retain];
  
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
  
  previousPageButton.hidden = currentPage == 1;
  nextPageBarButton.hidden = currentPage == lastPage;
  
  [myTableView reloadData];
  
  [autoreleasePool drain];
} // postFetchActions

-(void) performServiceFetch {  
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  [paginationDelegate performServiceFetchForPage:&currentPage
                                        lastPage:&lastPage
                                        progress:&fetching
                                     resultsData:&servicesData
                              performingSelector:@selector(postFetchActions)
                                        onTarget:self];
  
  [autoreleasePool drain];
} // performServiceFetch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  currentPageLabel.hidden = YES;
  previousPageButton.hidden = YES;
  nextPageBarButton.hidden = YES;
  
  [self startLoadingAnimation];
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (fetching || [services count] == 0) {
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
  if (fetching || [services count] == 0) {
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.detailTextLabel.text = @"Loading, Please Wait...";
    
    return cell;
  }
  
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
  [detailViewController loadView];

  // FIXME: threading issues
  [detailViewController updateWithProperties:[services objectAtIndex:indexPath.row]];
//  [NSThread detachNewThreadSelector:@selector(updateWithProperties:) 
//                           toTarget:detailViewController
//                         withObject:[services objectAtIndex:indexPath.row]];

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
  
  [paginationDelegate release];
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

