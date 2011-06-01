//
//  BioCatalogueResourceManager.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//


@interface BioCatalogueResourceManager : NSObject {
}

+(void) clearCache;

+(void) commitChanges;
+(BOOL) deleteObject:(NSManagedObject *)object;

+(BioCatalogue *) currentBioCatalogue;
+(User *) catalogueUser;

+(Announcement *) announcementWithUniqueID:(NSInteger)uniqueID;
+(Service *) serviceWithUniqueID:(NSInteger)uniqueID;

+(BOOL) serviceWithUniqueIDIsBeingMonitored:(NSInteger)uniqueID;
+(BOOL) serviceWithUniqueIDIsFavourited:(NSInteger)uniqueID;

@end
