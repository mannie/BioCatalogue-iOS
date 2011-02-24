//
//  UpdateCenter.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 24/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MWFeedParser.h"

#import "AppConstants.h"
#import "BioCatalogueResourceManager.h"

#import "AppDelegate_Shared.h"


@interface UpdateCenter : NSObject <MWFeedParserDelegate> {
  NSDateFormatter *dateFormatter;
}

+(void) updateApplicationBadgesForAnnouncements;
+(void) updateApplicationBadgesForServiceUpdates;

+(void) checkForAnnouncements:(NSArray **)latestAnnouncements performingSelector:(SEL)postActionsSelector onTarget:(id)target;
+(void) checkForServiceUpdates:(NSArray *)services performingSelector:(SEL)postActionsSelector onTarget:(id)target;

+(void) spawnUpdateCheckDaemon;

@end
