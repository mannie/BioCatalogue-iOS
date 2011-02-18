//
//  Service.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BioCatalogue;

@interface Service :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) BioCatalogue * catalogue;

@end



