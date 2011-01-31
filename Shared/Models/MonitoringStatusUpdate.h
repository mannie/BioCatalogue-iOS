//
//  MonitoringStatusUpdate.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface MonitoringStatusUpdate :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * passed;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSData * icon;

@end



