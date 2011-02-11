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

-(void) updateWithMonitoringStatusInfoForServiceWithID:(NSUInteger)serviceID {
  if (currentServiceID == serviceID) return;
  
  currentServiceID = serviceID;
  
  dispatch_async(dispatch_queue_create("Load provider services", NULL), ^{
    [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
    
    [monitoringInfo release];
    monitoringInfo = [[NSMutableDictionary alloc] init];
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    monitoringInfo = [[BioCatalogueClient monitoringStatusesForServiceWithID:currentServiceID] retain];
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
  });
} // updateWithMonitoringStausInfoForServiceWithID


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];

  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
  
  [UIContentController setTableViewBackground:[self tableView]];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[monitoringInfo objectForKey:JSONServiceTestsElement] count];
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  id status = [[[monitoringInfo objectForKey:JSONServiceTestsElement] objectAtIndex:indexPath.row] objectForKey:JSONStatusElement];

  NSArray *date = [[[dateFormatter dateFromString:[status objectForKey:JSONLastCheckedElement]] description] 
                   componentsSeparatedByString:@" "];

  cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@ at %@", 
                         [status objectForKey:JSONLabelElement], [date objectAtIndex:0], [date objectAtIndex:1]];
  cell.imageView.image = [UIImage imageNamed:
                          [[[NSURL URLWithString:[status objectForKey:@"small_symbol"]] absoluteString] lastPathComponent]];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id status = [[monitoringInfo objectForKey:JSONServiceTestsElement] objectAtIndex:indexPath.row];
  
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
  [activityIndicator release];
} // releaseIBOutlets

- (void)viewDidUnload {
  [dateFormatter release];
	[super viewDidUnload];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  
  [monitoringInfo release];
  
  [super dealloc];
} // dealloc


@end

