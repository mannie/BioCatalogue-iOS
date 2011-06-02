//
//  User.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BioCatalogue;
@class Service;

@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSSet* servicesFavourited;
@property (nonatomic, retain) NSSet* servicesResponsibleFor;
@property (nonatomic, retain) NSSet* servicesSubmitted;
@property (nonatomic, retain) BioCatalogue * catalogue;

@end


@interface User (CoreDataGeneratedAccessors)
- (void)addServicesFavouritedObject:(Service *)value;
- (void)removeServicesFavouritedObject:(Service *)value;
- (void)addServicesFavourited:(NSSet *)value;
- (void)removeServicesFavourited:(NSSet *)value;

- (void)addServicesResponsibleForObject:(Service *)value;
- (void)removeServicesResponsibleForObject:(Service *)value;
- (void)addServicesResponsibleFor:(NSSet *)value;
- (void)removeServicesResponsibleFor:(NSSet *)value;

- (void)addServicesSubmittedObject:(Service *)value;
- (void)removeServicesSubmittedObject:(Service *)value;
- (void)addServicesSubmitted:(NSSet *)value;
- (void)removeServicesSubmitted:(NSSet *)value;

@end

