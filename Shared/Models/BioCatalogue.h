//
//  BioCatalogue.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Announcement;
@class Service;
@class User;

@interface BioCatalogue :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * hostname;
@property (nonatomic, retain) NSSet* announcements;
@property (nonatomic, retain) NSSet* servicesMonitored;
@property (nonatomic, retain) User * user;

@end


@interface BioCatalogue (CoreDataGeneratedAccessors)
- (void)addAnnouncementsObject:(Announcement *)value;
- (void)removeAnnouncementsObject:(Announcement *)value;
- (void)addAnnouncements:(NSSet *)value;
- (void)removeAnnouncements:(NSSet *)value;

- (void)addServicesMonitoredObject:(Service *)value;
- (void)removeServicesMonitoredObject:(Service *)value;
- (void)addServicesMonitored:(NSSet *)value;
- (void)removeServicesMonitored:(NSSet *)value;

@end

