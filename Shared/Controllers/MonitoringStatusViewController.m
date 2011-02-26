//
//  MonitoringStatusViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation MonitoringStatusViewController

@synthesize iPhoneWebViewController;


#pragma mark -
#pragma mark Helpers

-(void) updateWithMonitoringStatusInfoForServiceWithID:(NSUInteger)serviceID {
  if (currentServiceID == serviceID) return;
  
  currentServiceID = serviceID;
  
  dispatch_async(dispatch_queue_create("Load provider services", NULL), ^{
    [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
    
    [monitoringInfo release];
    monitoringInfo = [[NSMutableDictionary alloc] init];
    
    [monitoringStatuses release];
    monitoringStatuses = [[NSMutableArray alloc] init];
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    monitoringInfo = [[BioCatalogueClient monitoringStatusesForServiceWithID:currentServiceID] retain];

    // sort items in reverse order
    NSArray *tests = [monitoringInfo objectForKey:JSONServiceTestsElement];
    for (int x = [tests count]; x > 0; x--) {
      [monitoringStatuses insertObject:[tests objectAtIndex:x-1] atIndex:[tests count]-x];
    }
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
  });
} // updateWithMonitoringStausInfoForServiceWithID


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController customiseTableView:[self tableView]];
} // viewDidLoad

-(void) viewWillAppear:(BOOL)animated {
  [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];

  if (!viewHasBeenUpdated && currentServiceID) [self updateWithMonitoringStatusInfoForServiceWithID:currentServiceID];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}

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
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
    
  // Configure the cell...
  id test = [monitoringStatuses objectAtIndex:[indexPath row]];
  id status = [test objectForKey:JSONStatusElement];
  
  NSString *testType = [[[test objectForKey:JSONTestTypeElement] allKeys] lastObject];
  if ([testType isEqualToString:JSONTestScriptElement]) {
    [[cell textLabel] setText:@"Test script execution"];
  } else if ([testType isEqualToString:JSONURLMonitorElement]) {
    [[cell textLabel] setText:@"Availability monitoring"];
  } else {
    [[cell textLabel] setText:@"Unknown test"];
  }

  [[cell detailTextLabel] setText:[[status objectForKey:JSONLastCheckedElement] stringByReformattingJSONDate:YES]];
  [[cell imageView] setImage:[UIImage imageNamed:[[status objectForKey:JSONSymbolElement] lastPathComponent]]];
  
  [UIContentController customiseTableViewCell:cell];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id status = [monitoringStatuses objectAtIndex:[indexPath row]];
  
  NSURL *url = [NSURL URLWithString:[status objectForKey:JSONResourceElement]];
  if ([[UIDevice currentDevice] isIPadDevice]) {
    AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
    DetailViewController_iPad *iPadDetailViewController = (DetailViewController_iPad *)[[[appDelegate splitViewController] viewControllers] lastObject];
    [iPadDetailViewController showResourceInPullOutBrowser:url];
  } else {
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:APIRequestTimeout];
    [(UIWebView *)[iPhoneWebViewController view] loadRequest:request];
    [[self navigationController] pushViewController:iPhoneWebViewController animated:YES];
  }

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [activityIndicator release];
  [webBrowserController release];
} // releaseIBOutlets

- (void)viewDidUnload {
	[super viewDidUnload];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  
  [monitoringStatuses release];
  [monitoringInfo release];
  
  [super dealloc];
} // dealloc


@end

