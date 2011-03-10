//
//  UpdateCenter.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation UpdateCenter

static NSMutableArray *announcements;
static BOOL currentlyFetchingAnnouncements;

static NSUInteger activeUpdateThreads;

static BOOL updateCheckDaemonShoundBeActive;


#pragma mark -
#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
  announcements = [[NSMutableArray alloc] init];

  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
	if (!item) return;

  int announcementID = [[[item link] lastPathComponent] intValue];
  Announcement *announcement = [BioCatalogueResourceManager announcementWithUniqueID:announcementID];
  
  if (![announcement date]) { // announcement was freshly created
    [announcement setDate:[item date]];
    [announcement setTitle:[item title]];
    [announcement setSummary:[item summary]];
    
    [BioCatalogueResourceManager commitChanges];
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
    [announcement setIsUnread:[NSNumber numberWithBool:NO]];
  }
  [BioCatalogueResourceManager commitChanges];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
  [error log];
	[announcements removeAllObjects];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
}


#pragma mark -
#pragma mark UI Update

+(void) updateApplicationBadgesForAnnouncements {
  NSPredicate *unreadItemsPredicate = [NSPredicate predicateWithFormat:@"isUnread = YES"];
  NSArray *unreadItems = [[[BioCatalogueResourceManager currentBioCatalogue] announcements] allObjects];
  unreadItems = [unreadItems filteredArrayUsingPredicate:unreadItemsPredicate];
  
  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  if ([unreadItems count] > 0) {
    [[appDelegate announcementsTabBarItem] setBadgeValue:[NSString stringWithFormat:@"%i", [unreadItems count]]];
  } else {
    [[appDelegate announcementsTabBarItem] setBadgeValue:nil];
  }
  
  int totalNoteWorthyItems = [[[appDelegate myStuffTabBarItem] badgeValue] intValue] + [unreadItems count];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalNoteWorthyItems];  
} // updateApplicationBadgesForAnnouncements

+(void) updateApplicationBadgesForServiceUpdates {
  NSPredicate *updatedServicesPredicate = [NSPredicate predicateWithFormat:@"hasUpdate = YES"];
  NSArray *updatedServices = [[[BioCatalogueResourceManager currentBioCatalogue] monitoredServices] allObjects];
  updatedServices = [updatedServices filteredArrayUsingPredicate:updatedServicesPredicate];
  
  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  if ([updatedServices count] > 0) {
    [[appDelegate myStuffTabBarItem] setBadgeValue:[NSString stringWithFormat:@"%i", [updatedServices count]]];
  } else {
    [[appDelegate myStuffTabBarItem] setBadgeValue:nil];
  }
  
  int totalNoteWorthyItems = [[[appDelegate announcementsTabBarItem] badgeValue] intValue] + [updatedServices count];
  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:totalNoteWorthyItems];  
} // updateApplicationBadgesForServiceUpdates


#pragma mark -
#pragma mark Check For Updates

+(void) checkForAnnouncements:(NSArray **)latestAnnouncements performingSelector:(SEL)postActionsSelector onTarget:(id)target {
  if (currentlyFetchingAnnouncements) return;
  
  MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:[[BioCatalogueClient announcementsFeedURL] absoluteString]];
  [feedParser setDelegate:[[[UpdateCenter alloc] init] autorelease]];
  [feedParser setFeedParseType:ParseTypeFull]; // OPTIONS:: ParseTypeFull || ParseTypeInfoOnly || ParseTypeItemsOnly
  [feedParser setConnectionType:ConnectionTypeSynchronously];

  currentlyFetchingAnnouncements = YES;
  [[feedParser autorelease] parse];
  currentlyFetchingAnnouncements = NO;
  
  if (*latestAnnouncements)   [*latestAnnouncements release];
  *latestAnnouncements = [[NSArray arrayWithArray:announcements] retain];
    
  if (target && [target respondsToSelector:postActionsSelector]) [target performSelector:postActionsSelector];
  
  [self performSelectorOnMainThread:@selector(updateApplicationBadgesForAnnouncements) withObject:nil waitUntilDone:NO];
  [announcements autorelease];
} // checkForAnnouncements:performingSelector:onTarget

-(void) handleUpdateStatusForService:(Service *)service withProperties:(NSDictionary *)serviceProperties {
  NSString *jsonDate = [[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement];
  if (![[NSString stringWithFormat:@"%@", jsonDate] isValidJSONValue]) return;
  
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:JSONDateFormat];
  }
  NSDate *liveDateOfUpdate = [dateFormatter dateFromString:jsonDate];
  BOOL serviceHasBeenUpdated = [liveDateOfUpdate laterDate:[service lastUpdated]] == liveDateOfUpdate;
  
  NSString *latestStatus = [[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLabelElement];
  serviceHasBeenUpdated = serviceHasBeenUpdated && ![[service latestMonitoringStatus] isEqualToString:latestStatus];
  
  if (!serviceHasBeenUpdated) return;
  
  [service setHasUpdate:[NSNumber numberWithBool:YES]];
  [service setLatestMonitoringStatus:latestStatus];
}

-(void) checkForUpdatesForServiceWithProperties:(NSDictionary *)serviceProperties {
  NSUInteger uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
  Service *service = [BioCatalogueResourceManager serviceWithUniqueID:uniqueID];
  
  if (![service lastUpdated]) { // is a new entry
    [service setLastUpdated:[NSDate date]];
    [service setLatestMonitoringStatus:[[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLabelElement]];
  } else { // has been checked before
    [self handleUpdateStatusForService:service withProperties:serviceProperties];
  }
} // checkForUpdatesForServiceWithProperties

-(void) checkForUpdatesForService:(Service *)service {
  NSDictionary *serviceProperties = [BioCatalogueClient documentAtPath:[NSString stringWithFormat:@"/%@/%@", ServiceResourceScope, [service uniqueID]]];
  [self handleUpdateStatusForService:service withProperties:serviceProperties];
} // checkForUpdatesForServiceWithProperties

+(void) checkForServiceUpdates:(NSArray *)services performingSelector:(SEL)postActionsSelector onTarget:(id)target {  
  if (activeUpdateThreads == 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
  }
  activeUpdateThreads++;
  
  UpdateCenter *updateChecker = [[UpdateCenter alloc] init];
  for (NSDictionary *serviceProperties in services) {
    [updateChecker checkForUpdatesForServiceWithProperties:serviceProperties];
  }
  [updateChecker release];
  
  activeUpdateThreads--;
  if (activeUpdateThreads == 0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
  }
  
  if (target && [target respondsToSelector:postActionsSelector]) [target performSelector:postActionsSelector];
  
  [self performSelectorOnMainThread:@selector(updateApplicationBadgesForServiceUpdates) withObject:nil waitUntilDone:NO];
} // checkForServiceUpdates

#pragma mark -
#pragma mark Thread to check for updates in the background

+(void) spawnUpdateCheckDaemon {
  updateCheckDaemonShoundBeActive = YES;
  
  UIApplication *application = [UIApplication sharedApplication];
  UIBackgroundTaskIdentifier updateCheckDaemon = [application beginBackgroundTaskWithExpirationHandler: ^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [application endBackgroundTask:updateCheckDaemon];
    });
  }];
  
  dispatch_async(dispatch_queue_create("Update daemon", NULL), ^{
    while (updateCheckDaemonShoundBeActive) {
      // this bit of code ensures that the application does not hang when it comes back into the foreground
      for (int i = 0; i < UpdateCheckInterval && updateCheckDaemonShoundBeActive; i++) {
        [NSThread sleepForTimeInterval:1];
      }
      if (!updateCheckDaemonShoundBeActive) break;
      
      // announcements
      NSArray *newAnnouncements = nil;
      [self checkForAnnouncements:&newAnnouncements performingSelector:NULL onTarget:nil];

      NSPredicate *unreadItemsPredicate = [NSPredicate predicateWithFormat:@"isUnread = YES"];
      newAnnouncements = [newAnnouncements filteredArrayUsingPredicate:unreadItemsPredicate];
      
      // monitored services status updates
      NSArray *serviceStatusUpdates = nil;
      if ([BioCatalogueClient userIsAuthenticated]) {
        serviceStatusUpdates = [[[BioCatalogueResourceManager currentBioCatalogue] monitoredServices] allObjects];
        UpdateCenter *updateChecker = [[UpdateCenter alloc] init];
        for (Service *service in serviceStatusUpdates) {
          [updateChecker checkForUpdatesForService:service];
        }
        [updateChecker release];        

        NSPredicate *updatedServicesPredicate = [NSPredicate predicateWithFormat:@"hasUpdate = YES"];
        serviceStatusUpdates = [serviceStatusUpdates filteredArrayUsingPredicate:updatedServicesPredicate];
      }

      BOOL newAnnouncementsAreAvailable = newAnnouncements && [newAnnouncements count] > 0;
      BOOL statusUpdatesAreAvailable = serviceStatusUpdates && [serviceStatusUpdates count] > 0;
      
      if (newAnnouncementsAreAvailable || statusUpdatesAreAvailable) {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];

        if (newAnnouncementsAreAvailable) {
          [localNotification setAlertBody:@"New unread announcements."];
          [self performSelectorOnMainThread:@selector(updateApplicationBadgesForAnnouncements) withObject:nil waitUntilDone:YES];
        } 
        
        if (statusUpdatesAreAvailable) {
          if (newAnnouncementsAreAvailable) {
            [localNotification setAlertBody:[NSString stringWithFormat:@"%@\n\nService status updates available.", [localNotification alertBody]]];
          } else {
            [localNotification setAlertBody:@"Service status updates available."];
          }
          
          [self performSelectorOnMainThread:@selector(updateApplicationBadgesForServiceUpdates) withObject:nil waitUntilDone:NO];
        }
        
        [localNotification setAlertAction:@"View"];
        
        [application presentLocalNotificationNow:localNotification];
        [localNotification release];

        break;
      }
    } // while
    
    [application endBackgroundTask:updateCheckDaemon];
  });  
} // spawnUpdateCheckDaemon

+(void) killUpdateCheckDaemon {
  updateCheckDaemonShoundBeActive = NO;
} // killUpdateCheckDaemon


#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  [dateFormatter release];
  [super dealloc];
}

@end
