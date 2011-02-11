//
//  AnnouncementsViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnouncementsViewController.h"


@implementation AnnouncementsViewController

@synthesize iPadDetailViewController, iPhoneDetailViewController;


-(void) updateApplicationBadges {
  NSPredicate *unreadItemsPredicate = [NSPredicate predicateWithFormat:@"isUnread = YES"];
  NSArray *unreadItems = [announcements filteredArrayUsingPredicate:unreadItemsPredicate];
  
  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  if ([unreadItems count] > 0) {
    appDelegate.announcementsTabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [unreadItems count]];
  } else {
    appDelegate.announcementsTabBarItem.badgeValue = nil;
  }
  
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[unreadItems count]];  
} // updateApplicationBadges


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  [feedParser parse];
} // refreshTableViewDataSource


#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	[announcements release];
  announcements = [[NSMutableArray alloc] init];

  [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [self updateApplicationBadges];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (!item) return;
  
  int announcementID = [[item.link lastPathComponent] intValue];
  Announcement *announcement = [BioCatalogueResourceManager announcementWithUniqueID:announcementID];
  
  if (!announcement.date) { // announcement was freshly created
    announcement.date = item.date;
    announcement.title = item.title;
    announcement.summary = item.summary;

    [BioCatalogueResourceManager commmitChanges];
  }
  
  [announcements addObject:announcement];	
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
  [announcements sortUsingDescriptors:[NSArray arrayWithObject:sort]];
  
  // 60 * 60 = 3600 seconds/hour; 3600 * 24 = 86400 seconds/day
  NSTimeInterval maxTimeIntervalBeforeUnreadItemsExpire = 86400 * DaysBeforeExpiringUnreadAnnouncements;
  
  NSDate *today = [NSDate date];
  NSDate *unreadItemsExpiryDate = [today dateByAddingTimeInterval:0-maxTimeIntervalBeforeUnreadItemsExpire];
  
  NSPredicate *expiredItemsPredicate = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {
    BOOL isUnread = [[evaluatedObject isUnread] boolValue];
    BOOL isExpired = [[[evaluatedObject date] laterDate:unreadItemsExpiryDate] isEqualToDate:unreadItemsExpiryDate];
    if (isUnread & isExpired) return YES;
    else return NO;
  }];

  NSArray *expiredAnnouncements = [announcements filteredArrayUsingPredicate:expiredItemsPredicate];
  for (Announcement *announcement in expiredAnnouncements) {
    announcement.isUnread = [NSNumber numberWithBool:NO];
  }
  [BioCatalogueResourceManager commmitChanges];
  
	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [self updateApplicationBadges];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
	NSLog(@"Finished Parsing With Error: %@", error);
	[announcements removeAllObjects];

	[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [self updateApplicationBadges];
}


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];
  
  feedParser = [[MWFeedParser alloc] initWithFeedURL:[[BioCatalogueClient announcementsFeedURL] absoluteString]];
  feedParser.delegate = self;
  feedParser.feedParseType = ParseTypeFull; // OPTIONS:: ParseTypeFull || ParseTypeInfoOnly || ParseTypeItemsOnly
  feedParser.connectionType = ConnectionTypeSynchronously;
  
  announcements = [[NSMutableArray alloc] init];
  
  [self refreshTableViewDataSource];
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
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  Announcement *announcement = [announcements objectAtIndex:indexPath.row];
  cell.textLabel.text = announcement.title;
    
//  NSArray *date = [[announcement.date description] componentsSeparatedByString:@" "];
//  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@", [date objectAtIndex:0], [date objectAtIndex:1]];
  NSRange range = NSMakeRange(90, [announcement.summary length]-90);
  cell.detailTextLabel.text = [[announcement.summary stringByReplacingCharactersInRange:range withString:@""] 
                               stringByConvertingHTMLToPlainText];
  
  if ([announcement.isUnread boolValue]) {
    cell.imageView.image = [UIImage imageNamed:AnnouncementUnreadIcon];
    cell.imageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
  } else {
    cell.imageView.image = [UIImage imageNamed:AnnouncementReadIcon];
    cell.imageView.backgroundColor = [UIColor clearColor];
  }
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
  Announcement *announcement = [announcements objectAtIndex:indexPath.row];

  if ([[UIDevice currentDevice] isIPadDevice]) {
    [iPadDetailViewController startLoadingAnimation];
    [iPadDetailViewController updateWithPropertiesForAnnouncementWithID:[announcement.uniqueID intValue]];
    [iPadDetailViewController stopLoadingAnimation];
  } else {
    [iPhoneDetailViewController loadView];
    [iPhoneDetailViewController updateWithPropertiesForAnnouncementWithID:[announcement.uniqueID intValue]];
    [self.navigationController pushViewController:iPhoneDetailViewController animated:YES];
  }

// [[self tableView] reloadData];
//  [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [self updateApplicationBadges];
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [iPhoneDetailViewController release];
  [iPadDetailViewController release];
}

- (void)viewDidUnload {
  [feedParser release];
	[super viewDidUnload];
}

- (void)dealloc {
  [self releaseIBOutlets];
  [announcements release];
  
  [super dealloc];
}


@end

