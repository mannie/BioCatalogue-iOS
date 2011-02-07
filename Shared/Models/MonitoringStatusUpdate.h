//
//  MonitoringStatusUpdate.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Service;

@interface MonitoringStatusUpdate :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSData * icon;
@property (nonatomic, retain) Service * service;

@end



