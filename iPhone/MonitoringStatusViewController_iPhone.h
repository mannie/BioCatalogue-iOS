//
//  MonitoringStatusTableController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"


@interface MonitoringStatusViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSDictionary *monitoringProperties;
  NSArray *monitoringStatuses;
  
  IBOutlet UITableView *myTableView;
  IBOutlet UILabel *loadingLabel;
}

-(void) fetchMonitoringStatusInfo:(NSString *)fromPath;
-(void) updateWithProperties:(NSDictionary *)properties;

@end
