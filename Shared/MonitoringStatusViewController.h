//
//  MonitoringStatusViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"

@class DetailViewController_iPad;


@interface MonitoringStatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSDictionary *monitoringProperties;
  NSArray *monitoringStatuses;
  
  IBOutlet UITableView *myTableView;
  
  IBOutlet id detailViewController;
  
  NSString *lastUsedPath;
  
  BOOL fetching;
  
  NSDateFormatter *dateFormatter;
}

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath;

@end
