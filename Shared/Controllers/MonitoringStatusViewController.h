//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class WebViewController_iPhone;


@interface MonitoringStatusViewController : UITableViewController {
  NSUInteger currentServiceID;
  
  NSMutableDictionary *monitoringInfo;
  NSMutableArray *monitoringStatuses;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
  IBOutlet WebBrowserController *webBrowserController;
  
  BOOL viewHasBeenUpdated;
}

-(void) updateWithMonitoringStatusInfoForServiceWithID:(NSUInteger)serviceID;

@property (nonatomic, retain) IBOutlet WebViewController_iPhone *iPhoneWebViewController;

@end
