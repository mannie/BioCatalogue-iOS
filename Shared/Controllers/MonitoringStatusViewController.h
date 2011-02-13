//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BioCatalogueClient.h"
#import "UIContentController.h"


@interface MonitoringStatusViewController : UITableViewController {
  NSUInteger currentServiceID;
  
  NSMutableDictionary *monitoringInfo;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
    
  NSDateFormatter *dateFormatter;

  BOOL viewHasBeenUpdated;
}

-(void) updateWithMonitoringStatusInfoForServiceWithID:(NSUInteger)serviceID;

@end
