//
//  BioCatalogueResourceManager.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate_Shared.h"

#import "BioCatalogue.h"
#import "User.h"
#import "Service.h"
#import "Announcement.h"


@interface BioCatalogueResourceManager : NSObject {
}

+(void) commmitChanges;

+(BioCatalogue *) currentBioCatalogue;
+(User *) currentUser;

+(NSArray *) currentBioCatalogueAnnouncements;

+(NSArray *) currentUserSubmittedServices;
+(NSArray *) currentUserFavouritedServices;

+(Announcement *) announcementWithUniqueID:(NSInteger)uniqueID;
+(Service *) serviceWithUniqueID:(NSInteger)uniqueID;

+(void) favouriteServiceWithProperties:(NSDictionary *)properties;

@end
