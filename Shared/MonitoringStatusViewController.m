//
//  MonitoringStatusViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MonitoringStatusViewController.h"
#import "DetailViewController_iPad.h"


@implementation MonitoringStatusViewController


#pragma mark -
#pragma mark Helpers

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  [myTableView setTableHeaderView:loadingLabel];
  [self updateWithProperties:[[JSON_Helper helper] documentAtPath:fromPath]];

  if ([[[UIDevice currentDevice] model] isEqualToString:iPadDevice]) {
      [detailViewController stopLoadingAnimation];
  }
  
  [autoreleasePool drain];
} // fetchMonitoringStatusInfo

-(void) updateWithProperties:(NSDictionary *)properties {
  [monitoringProperties release];
  monitoringProperties = [properties copy];
  
  [monitoringStatuses release];
  monitoringStatuses = [[properties objectForKey:JSONServiceTestsElement] copy];
  
  [myTableView reloadData];
  [myTableView setTableHeaderView:nil];
} // updateWithProperties


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
 [super viewDidLoad];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [monitoringStatuses count];
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  id status = [[monitoringStatuses objectAtIndex:indexPath.row] objectForKey:JSONStatusElement];
  
  NSString *date = [[status objectForKey:JSONLastCheckedElement] stringByReplacingCharactersInRange:NSMakeRange(10, 10)
                                                                                         withString:@""];
  cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@", [status objectForKey:JSONLabelElement], date];
  cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[status objectForKey:@"small_symbol"]]]];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id status = [monitoringStatuses objectAtIndex:indexPath.row];
  
  NSString *message = [NSString stringWithFormat:@"A URL monitoring test was performed on the endpoint: \n\n %@", 
                       [[[status objectForKey:JSONTestTypeElement] objectForKey:JSONURLMonitorElement] objectForKey:JSONURLElement]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring" 
                                                  message:message
                                                 delegate:self 
                                        cancelButtonTitle:@"OK" 
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [detailViewController release];
  
  [loadingLabel release];
  [myTableView release]; 
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
  [self releaseIBOutlets];
  
  [monitoringProperties release];
  [monitoringStatuses release];
  
  [super dealloc];
} // dealloc


@end

