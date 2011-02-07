//
//  BioCatalogue.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Announcement;
@class User;

@interface BioCatalogue :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * hostname;
@property (nonatomic, retain) NSSet* users;
@property (nonatomic, retain) NSSet* announcements;

@end


@interface BioCatalogue (CoreDataGeneratedAccessors)
- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)value;
- (void)removeUsers:(NSSet *)value;

- (void)addAnnouncementsObject:(Announcement *)value;
- (void)removeAnnouncementsObject:(Announcement *)value;
- (void)addAnnouncements:(NSSet *)value;
- (void)removeAnnouncements:(NSSet *)value;

@end

