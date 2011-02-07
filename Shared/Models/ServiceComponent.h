//
//  ServiceComponent.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Service;

@interface ServiceComponent :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) Service * service;

@end



