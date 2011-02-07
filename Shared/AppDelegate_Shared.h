//
//  AppDelegate_Shared.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BioCatalogueClient.h"


@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
  UIWindow *window;
  
@private
  NSManagedObjectContext *managedObjectContext_;
  NSManagedObjectModel *managedObjectModel_;
  NSPersistentStoreCoordinator *persistentStoreCoordinator_;
  
  NSUInteger networkActivityCounter;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarItem *announcementsTabBarItem;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(void) incrementNetworkActivity:(NSNotification *)notification;
-(void) decrementNetworkActivity:(NSNotification *)notification;

-(BOOL) applicationStartConditionsMet;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

