//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"


@interface MonitoringStatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSDictionary *monitoringProperties;
  NSArray *monitoringStatuses;
  
  IBOutlet UITableView *myTableView;
    
  IBOutlet UIActivityIndicatorView *activityIndicator;
  
  NSString *lastUsedPath;
    
  NSDateFormatter *dateFormatter;
}

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath;

@end
