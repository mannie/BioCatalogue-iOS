//
//  Provider.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Service;

@interface Provider :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSSet* services;

@end


@interface Provider (CoreDataGeneratedAccessors)
- (void)addServicesObject:(Service *)value;
- (void)removeServicesObject:(Service *)value;
- (void)addServices:(NSSet *)value;
- (void)removeServices:(NSSet *)value;

@end

