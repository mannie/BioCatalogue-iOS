//
//  Service.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BioCatalogue;

@interface Service :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) BioCatalogue * catalogue;
@property (nonatomic, retain) NSNumber * hasUpdate;
@property (nonatomic, retain) NSString * latestMonitoringStatus;

@end



