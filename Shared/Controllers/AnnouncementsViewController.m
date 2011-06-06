//
//  AnnouncementsViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation AnnouncementsViewController

@synthesize iPadDetailViewController, iPhoneDetailViewController;




#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) reloadTableView {
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
}

-(void) refreshTableViewDataSource {
  [announcements release];
  announcements = [[NSArray alloc] init];

  [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

  [UpdateCenter checkForAnnouncements:&announcements performingSelector:@selector(reloadTableView) onTarget:self];
} // refreshTableViewDataSource


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];

  [UIContentController customiseTableView:[self tableView]];
 
  dispatch_async(dispatch_queue_create("Load content", NULL), ^{
    [self refreshTableViewDataSource];
  });
} // viewDidLoad


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [announcements count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellXIB owner:self options:nil] lastObject];
  }
  
  // Configure the cell...
  if ([announcements count] == 0) return cell;
  
  [UIContentController populateTableViewCell:cell
                                  withObject:[announcements objectAtIndex:[indexPath row]]
                                  givenScope:AnnouncementResourceScope];
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Announcement *announcement = [announcements objectAtIndex:[indexPath row]];

  if ([[UIDevice currentDevice] isIPadDevice]) {
    [iPadDetailViewController startLoadingAnimation];
    [iPadDetailViewController updateWithPropertiesForAnnouncementWithID:[[announcement uniqueID] intValue]];
  } else {    
    if (![iPhoneDetailViewController view]) [iPhoneDetailViewController loadView];
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPhoneDetailViewController updateWithPropertiesForAnnouncementWithID:[[announcement uniqueID] intValue]];
    });
    
    [[self navigationController] pushViewController:iPhoneDetailViewController animated:YES];
  }

  if ([[announcement isUnread] boolValue]) {
    [announcement setIsUnread:[NSNumber numberWithBool:NO]];
    [BioCatalogueResourceManager commitChanges];
    
    [UpdateCenter performSelectorOnMainThread:@selector(updateApplicationBadgesForAnnouncements) withObject:nil waitUntilDone:NO];
  }
  
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];  
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [iPhoneDetailViewController release];
  [iPadDetailViewController release];
  [activityIndicator release];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [announcements release];
  
  [super dealloc];
}


@end

