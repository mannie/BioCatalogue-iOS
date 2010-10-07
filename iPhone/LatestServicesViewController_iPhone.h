//
//  LatestServicesViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"

@interface LatestServicesViewController_iPhone : UITableViewController {
  NSArray *latestServices;
  
  UITableViewCell *serviceCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *serviceCell;

@end
