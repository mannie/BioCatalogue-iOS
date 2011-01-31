// 
//  Service.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Service.h"

#import "MonitoringStatusUpdate.h"
#import "Provider.h"
#import "ServiceComponent.h"
#import "User.h"

@implementation Service 

@dynamic name;
@dynamic uniqueID;
@dynamic type;
@dynamic latestMonitoringIcon;
@dynamic about;
@dynamic provider;
@dynamic monitoringUpdates;
@dynamic components;
@dynamic submitter;

-(NSData *) latestMonitoringIcon {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
  NSArray *updates = [[self monitoringUpdates] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
  return [[updates lastObject] icon];
}

@end
