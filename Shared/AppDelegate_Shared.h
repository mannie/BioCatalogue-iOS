//
//  AppDelegate_Shared.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


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
@property (nonatomic, retain) IBOutlet UITabBarItem *myStuffTabBarItem;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

-(void) incrementNetworkActivity:(NSNotification *)notification;
-(void) decrementNetworkActivity:(NSNotification *)notification;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

