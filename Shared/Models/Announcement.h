//
//  Announcement.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class BioCatalogue;

@interface Announcement :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * uniqueID;
@property (nonatomic, retain) NSNumber * isUnread;
@property (nonatomic, retain) BioCatalogue * catalogue;

@end



