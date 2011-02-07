//
//  Service.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class MonitoringStatusUpdate;
@class Provider;
@class ServiceComponent;
@class User;

@interface Service :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData * latestMonitoringIcon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) User * submitter;
@property (nonatomic, retain) Provider * provider;
@property (nonatomic, retain) NSSet* monitoringUpdates;
@property (nonatomic, retain) NSSet* components;

@end


@interface Service (CoreDataGeneratedAccessors)
- (void)addMonitoringUpdatesObject:(MonitoringStatusUpdate *)value;
- (void)removeMonitoringUpdatesObject:(MonitoringStatusUpdate *)value;
- (void)addMonitoringUpdates:(NSSet *)value;
- (void)removeMonitoringUpdates:(NSSet *)value;

- (void)addComponentsObject:(ServiceComponent *)value;
- (void)removeComponentsObject:(ServiceComponent *)value;
- (void)addComponents:(NSSet *)value;
- (void)removeComponents:(NSSet *)value;

@end

