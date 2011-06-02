//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


@interface MonitoringStatusViewController : UITableViewController {
  NSUInteger currentServiceID;
  
  NSMutableDictionary *monitoringInfo;
  NSMutableArray *monitoringStatuses;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
  
  BOOL viewHasBeenUpdated;
}

-(void) updateWithMonitoringStatusInfoForServiceWithID:(NSUInteger)serviceID;

@end
