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


#pragma mark -
#pragma mark Helpers

-(void) startAnimatingActivityIndicator {
  [activityIndicator startAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  
  currentPageLabel.alpha = 0.1;
  
  [UIView commitAnimations];
} // startAnimatingActivityIndicator

-(void) stopAnimatingActivityIndicator {
  [activityIndicator stopAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  
  currentPageLabel.alpha = 1;
  
  [UIView commitAnimations];
} // stopAnimatingActivityIndicator

-(void) performServiceFetch {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
  fetching = YES;
  [services release];
  
  if (currentPage < 1) {
    currentPage = 1;
  }
  
  if (lastPage < 1) {
    NSDictionary *servicesDocument = [[JSON_Helper helper] documentAtPath:@"services"];
    services = [[servicesDocument objectForKey:JSONResultsElement] copy];
    lastPage = [[servicesDocument objectForKey:JSONPagesElement] intValue];
    
    [myTableView setTableHeaderView:nil];
    currentPageLabel.hidden = NO;
  } else {
    services = [[[JSON_Helper helper] services:ServicesPerPage page:currentPage] copy];
  }
  
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
  
  previousPageButton.hidden = currentPage == 1;
  nextPageBarButton.hidden = currentPage == lastPage;
  
  fetching = NO;
  [myTableView reloadData];
  
  [self stopAnimatingActivityIndicator];
  
  [autoreleasePool drain];
} // performServiceFetch


#pragma mark -
#pragma mark IBActions

-(IBAction) loadServicesOnNextPage:(id)sender {
  if (!fetching) {
    if ([services count] > 0) {
      currentPage++;
    }
    [self startAnimatingActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
  }
} // loadServicesOnNextPage

-(IBAction) loadServicesOnPreviousPage:(id)sender {
  if (!fetching) {
    if (currentPage > 1) {
      currentPage--;
    }
    [self startAnimatingActivityIndicator];
    [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
  }
} // loadServicesOnPreviousPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  currentPageLabel.hidden = YES;
  previousPageButton.hidden = YES;
  nextPageBarButton.hidden = YES;
  
  currentPage = 0;
  lastPage = 0;
  
  [self startAnimatingActivityIndicator];
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
} // numberOfSectionsInTableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [services count];
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
  [loadingLabel release];
  
  [myTableView release];
  [activityIndicator release];
  
  [detailViewController release];
  [navigationController release];
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

