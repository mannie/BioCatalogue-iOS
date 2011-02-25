//
//  BioCatalogueResourceManager.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueResourceManager.h"


@implementation BioCatalogueResourceManager


static NSManagedObjectContext *managedObjectContext;


+(void) nukeDataStore {
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"BioCatalogue" inManagedObjectContext:managedObjectContext];
  
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  
  NSArray *items = [managedObjectContext executeFetchRequest:[request autorelease] error:nil];
  for (BioCatalogue *catalogue in items) {
    [managedObjectContext deleteObject:catalogue];
  }
  [self commitChanges];
  
  [@"Data store has been nuked!!!" print];
}

+(void) initialize {
  AppDelegate_Shared *delegate = (AppDelegate_Shared *)[UIApplication sharedApplication].delegate;
  managedObjectContext = delegate.managedObjectContext;

//  [self nukeDataStore];
} // initialize

+(void) commitChanges {  
  int maxNumberOfTimesToTryObtainingLock = 10;
  
  for (int x = 0; x < maxNumberOfTimesToTryObtainingLock; x++) {
    if ([managedObjectContext tryLock]) {
      NSError *error = nil;
      [managedObjectContext save:&error];
      if (error) [error log];
            
      [managedObjectContext unlock];
      break;
    }
  } 
} // commmitChanges

+(BOOL) deleteObject:(NSManagedObject *)object {
  [managedObjectContext deleteObject:object];
  return [object isDeleted];
} // deleteObject

+(BioCatalogue *) currentBioCatalogue {
  NSError *error = nil;
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"BioCatalogue"
                                            inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setFetchLimit:1];
  [request setPredicate:[NSPredicate predicateWithFormat:@"hostname = %@", BioCatalogueHostname]];

  BioCatalogue *catalogue = [[managedObjectContext executeFetchRequest:[request autorelease]
                                                                 error:&error] lastObject];
  if (error) [error log];
  if (catalogue) return catalogue;

  catalogue = [NSEntityDescription insertNewObjectForEntityForName:@"BioCatalogue" 
                                            inManagedObjectContext:managedObjectContext];

  catalogue.hostname = BioCatalogueHostname;
  
  [self commitChanges];
  
  return catalogue;
} // currentBioCatalogue

+(User *) catalogueUser {
  User *user = [[self currentBioCatalogue] user];
  if (user) return user;
  
  user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:managedObjectContext];
  user.catalogue = [self currentBioCatalogue];
  
  [self commitChanges];
  
  return user;
} // currentUser

+(Announcement *) announcementWithUniqueID:(NSInteger)uniqueID {
  NSError *error = nil;
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Announcement"
                                            inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setFetchLimit:1];
  [request setPredicate:[NSPredicate predicateWithFormat:@"uniqueID = %i", uniqueID]];
  
  Announcement *announcement = [[managedObjectContext executeFetchRequest:[request autorelease] error:&error] lastObject];
  if (error) [error log];
  
  if (announcement) return announcement;
  
  announcement = [NSEntityDescription insertNewObjectForEntityForName:@"Announcement" inManagedObjectContext:managedObjectContext];
  announcement.uniqueID = [NSNumber numberWithInt:uniqueID];
  announcement.catalogue = [self currentBioCatalogue];

  [self commitChanges];
  
  return announcement;
} // announcementWithUniqueID

+(Service *) serviceWithUniqueID:(NSInteger)uniqueID {
  NSError *error = nil;
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Service"
                                            inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setFetchLimit:1];
  [request setPredicate:[NSPredicate predicateWithFormat:@"uniqueID = %i", uniqueID]];
  
  Service *service = [[managedObjectContext executeFetchRequest:[request autorelease] error:&error] lastObject];
  if (error) [error log];
  
  if (service) return service;
  
  service = [NSEntityDescription insertNewObjectForEntityForName:@"Service" inManagedObjectContext:managedObjectContext];
  service.uniqueID = [NSNumber numberWithInt:uniqueID];
  service.catalogue = [self currentBioCatalogue];

  [self commitChanges];
  
  return service;
} // serviceWithUniqueID

+(BOOL) collection:(NSSet *)aCollection hasItemWithUniqueID:(NSInteger)uniqueID {
  for (id item in [aCollection allObjects]) {
    if ([[item uniqueID] intValue] == uniqueID) return YES;
  }
  
  return NO;
} // collection:hasItemWithUniqueID

+(BOOL) serviceWithUniqueIDIsBeingMonitored:(NSInteger)uniqueID {
  return [self collection:[[self currentBioCatalogue] monitoredServices] hasItemWithUniqueID:uniqueID];
} // serviceWithUniqueIDIsBeingMonitored

+(BOOL) serviceWithUniqueIDIsFavourited:(NSInteger)uniqueID {
  return [self collection:[[self catalogueUser] servicesFavourited] hasItemWithUniqueID:uniqueID];
} // serviceWithUniqueIDIsFavourited


@end
