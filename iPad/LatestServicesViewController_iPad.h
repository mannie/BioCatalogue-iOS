//
//  LatestServicesViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 04/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceDetailViewController_iPad.h"


@interface LatestServicesViewController_iPad : UITableViewController {
  ServiceDetailViewController_iPad *serviceDetailViewController;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPad *serviceDetailViewController;

@end
