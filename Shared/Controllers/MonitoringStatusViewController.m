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

-(void) updateWithProperties:(NSDictionary *)properties {
  [monitoringProperties release];
  monitoringProperties = [properties retain];
  
  [monitoringStatuses release];
  monitoringStatuses = [[properties objectForKey:JSONServiceTestsElement] retain];

  [self.tableView reloadData];
} // updateWithProperties

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath {
  if (![lastUsedPath isEqualToString:fromPath]) {
    [activityIndicator performSelectorOnMainThread:@selector(startAnimating)
                                        withObject:nil
                                     waitUntilDone:NO];
    [self.tableView performSelectorOnMainThread:@selector(setTableHeaderView:) 
                                     withObject:loadingView
                                  waitUntilDone:NO];
    
    [monitoringStatuses release];
    monitoringStatuses = [[NSArray array] retain];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) 
                                     withObject:nil 
                                  waitUntilDone:NO];

    [lastUsedPath release];
    lastUsedPath = [fromPath retain];
    
    [self updateWithProperties:[BioCatalogueClient documentAtPath:fromPath]];

    [activityIndicator stopAnimating];
  }

  [self.tableView setTableHeaderView:nil];
} // fetchMonitoringStatusInfo


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];

  dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
  
  [UIContentController setBrushedMetalBackground:self.tableView];
  
  if (!loadingView) loadingView = [[self.tableView tableHeaderView] retain];
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
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  id status = [[monitoringStatuses objectAtIndex:indexPath.row] objectForKey:JSONStatusElement];

  NSArray *date = [[[dateFormatter dateFromString:[status objectForKey:JSONLastCheckedElement]] description] 
                   componentsSeparatedByString:@" "];

  cell.textLabel.text = [NSString stringWithFormat:@"%@ on %@ at %@", 
                         [status objectForKey:JSONLabelElement], [date objectAtIndex:0], [date objectAtIndex:1]];
  cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                 [NSURL URLWithString:[status objectForKey:@"small_symbol"]]]];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id status = [monitoringStatuses objectAtIndex:indexPath.row];
  
  NSString *message = [NSString stringWithFormat:@"A URL monitoring test was performed on the endpoint: \n\n %@", 
                       [[[status objectForKey:JSONTestTypeElement] objectForKey:JSONURLMonitorElement] 
                        objectForKey:JSONURLElement]];
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

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [dateFormatter release];
  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  
  [monitoringProperties release];
  [monitoringStatuses release];
  
  [lastUsedPath release];
  
  [super dealloc];
} // dealloc


@end

