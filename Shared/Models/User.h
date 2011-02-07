//
//  User.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BioCatalogue;
@class Location;
@class Service;

@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSDate * dateJoined;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * affiliation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Location * location;
@property (nonatomic, retain) NSSet* services;
@property (nonatomic, retain) NSSet* favourites;
@property (nonatomic, retain) BioCatalogue * catalogue;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addServicesObject:(Service *)value;
- (void)removeServicesObject:(Service *)value;
- (void)addServices:(NSSet *)value;
- (void)removeServices:(NSSet *)value;

- (void)addFavouritesObject:(Service *)value;
- (void)removeFavouritesObject:(Service *)value;
- (void)addFavourites:(NSSet *)value;
- (void)removeFavourites:(NSSet *)value;

@end

