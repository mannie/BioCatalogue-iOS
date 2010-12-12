//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebAccessController.h"


@interface MonitoringStatusViewController : UITableViewController {
  NSDictionary *monitoringProperties;
  NSArray *monitoringStatuses;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
  
  NSString *lastUsedPath;
  
  NSDateFormatter *dateFormatter;
  
  UIView *loadingView;
}

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath;

@end
