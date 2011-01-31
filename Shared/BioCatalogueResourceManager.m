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

  error = nil;
  _currentBioCatalogue = [[NSEntityDescription insertNewObjectForEntityForName:@"BioCatalogue" 
                                                        inManagedObjectContext:managedObjectContext] retain];
  _currentBioCatalogue.hostname = BioCatalogueHostname;
  
  [managedObjectContext save:&error];
  if (error) [error log];
  
  return _currentBioCatalogue;
} // currentBioCatalogue

+(User *) currentUser {
  if (_currentUser) return _currentUser;
  
  _currentUser = [[[[self currentBioCatalogue] users] anyObject] retain];
  if (_currentUser) return _currentUser;
  
  NSError *error = nil;
  _currentUser = [[NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                inManagedObjectContext:managedObjectContext] retain];
  
  [managedObjectContext save:&error];
  if (error) [error log];
  
  return _currentUser;
} // currentUser

+(NSArray *) currentUserSubmittedServices {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  return [[[self currentUser] services] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
} // currentUserSubmitterServices

+(NSArray *) currentUserFavouritedServices {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  return [[[self currentUser] favourites] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
} // currentUserFavouritedServices

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
  
  [managedObjectContext save:&error];
  if (error) [error log];
  
  return service;
}

+(void) favouriteServiceWithProperties:(NSDictionary *)properties {
  NSString *uniqueID = [[properties objectForKey:JSONSelfElement] lastPathComponent];  
  Service *service = [self serviceWithUniqueID:[uniqueID intValue]];

  if (!service.name) {
    service.name = [properties objectForKey:JSONNameElement];
    NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
    service.about = ([description isValidJSONValue] ? description : NoDescriptionText);
  }

  [[self currentUser] addFavouritesObject:service];
  
  NSError *error = nil;
  [managedObjectContext save:&error];
  if (error) [error log];
} // favouriteServiceWithProperties


@end
