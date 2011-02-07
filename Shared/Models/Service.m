// 
//  Service.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Service.h"

#import "MonitoringStatusUpdate.h"
#import "Provider.h"
#import "ServiceComponent.h"
#import "User.h"

@implementation Service 

@dynamic uniqueID;
@dynamic type;
@dynamic latestMonitoringIcon;
@dynamic name;
@dynamic about;
@dynamic submitter;
@dynamic provider;
@dynamic monitoringUpdates;
@dynamic components;

@end
