//
//  BioCatalogue.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class User;

@interface BioCatalogue :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * hostname;
@property (nonatomic, retain) NSSet* users;

@end


@interface BioCatalogue (CoreDataGeneratedAccessors)
- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)value;
- (void)removeUsers:(NSSet *)value;

@end

