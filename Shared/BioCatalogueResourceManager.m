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

static BioCatalogue* _currentBioCatalogue;
static User* _currentUser;


+(void) initialize {
  AppDelegate_Shared *delegate = (AppDelegate_Shared *)[UIApplication sharedApplication].delegate;
  managedObjectContext = delegate.managedObjectContext;
} // initialize

+(void) commmitChanges {
  NSError *error = nil;
  [managedObjectContext save:&error];
  if (error) [error log];
}

+(BioCatalogue *) currentBioCatalogue {
  if (_currentBioCatalogue) return _currentBioCatalogue;
  
  NSError *error = nil;
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"BioCatalogue"
                                            inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entity];
  [request setFetchLimit:1];
  [request setPredicate:[NSPredicate predicateWithFormat:@"hostname = %@", BioCatalogueHostname]];

  _currentBioCatalogue = [[[managedObjectContext executeFetchRequest:[request autorelease] error:&error] lastObject] retain];
  if (error) [error log];
  if (_currentBioCatalogue) return _currentBioCatalogue;

  _currentBioCatalogue = [[NSEntityDescription insertNewObjectForEntityForName:@"BioCatalogue" 
                                                        inManagedObjectContext:managedObjectContext] retain];
  _currentBioCatalogue.hostname = BioCatalogueHostname;
  
  [self commmitChanges];
  
  return _currentBioCatalogue;
} // currentBioCatalogue

+(User *) currentUser {
  if (_currentUser) return _currentUser;
  
  _currentUser = [[[[self currentBioCatalogue] users] anyObject] retain];
  if (_currentUser) return _currentUser;
  
  _currentUser = [[NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                inManagedObjectContext:managedObjectContext] retain];
  
  [self commmitChanges];
  
  return _currentUser;
} // currentUser

+(NSArray *) currentBioCatalogueAnnouncements {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
  return [[[self currentBioCatalogue] announcements] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
} // currentBioCatalogueAnnouncements

+(NSArray *) currentUserSubmittedServices {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  return [[[self currentUser] services] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
} // currentUserSubmitterServices

+(NSArray *) currentUserFavouritedServices {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  return [[[self currentUser] favourites] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
} // currentUserFavouritedServices

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

  [self commmitChanges];
  
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
  
  [self commmitChanges];
  
  return service;
} // serviceWithUniqueID

+(void) favouriteServiceWithProperties:(NSDictionary *)properties {
  NSString *uniqueID = [[properties objectForKey:JSONSelfElement] lastPathComponent];  
  Service *service = [self serviceWithUniqueID:[uniqueID intValue]];

  if (!service.name) {
    service.name = [properties objectForKey:JSONNameElement];
    NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
    service.about = ([description isValidJSONValue] ? description : NoDescriptionText);
  }

  [[self currentUser] addFavouritesObject:service];
  
  [self commmitChanges];
} // favouriteServiceWithProperties


@end
