//
//  MonitoringStatusTableViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"


@interface MonitoringStatusTableViewController_iPhone : UITableViewController {
  NSDictionary *monitoringProperties;
  NSArray *monitoringStatuses;
  
  IBOutlet UILabel *loadingLabel;
}

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath;
-(void) updateWithProperties:(NSDictionary *)properties;

@end
