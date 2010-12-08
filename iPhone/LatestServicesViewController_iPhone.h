//
//  LatestServicesViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"
#import "UIView+Helper.h"
#import "NSOperationQueue+Helper.h"

#import "ServiceDetailViewController_iPhone.h"
#import "PaginationController.h"


@interface LatestServicesViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource> {  
  NSDictionary *servicesData;
  NSArray *services;
    
  ServiceDetailViewController_iPhone *detailViewController;

  UINavigationController *navigationController;

  int currentPage;
  int lastPage;
  
  IBOutlet UITableView *myTableView;
  IBOutlet UIActivityIndicatorView *activityIndicator;
 
  BOOL fetching;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *detailViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet PaginationController *paginationController;

@end
