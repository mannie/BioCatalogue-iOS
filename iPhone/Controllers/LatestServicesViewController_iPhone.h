//
//  LatestServicesViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebAccessController.h"

#import "ServiceDetailViewController_iPhone.h"
#import "PaginationController.h"


@interface LatestServicesViewController_iPhone : UITableViewController {  
  NSArray *services;
    
  ServiceDetailViewController_iPhone *detailViewController;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *detailViewController;
@property (nonatomic, retain) IBOutlet PaginationController *paginationController;

@end
