//
//  LatestServicesViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"
#import "ServiceDetailViewController_iPhone.h"
#import "UIView+Helper.h"


@interface LatestServicesViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource> {  
  NSArray *services;
    
  ServiceDetailViewController_iPhone *detailViewController;

  UINavigationController *navigationController;

  NSUInteger currentPage;
  NSUInteger lastPage;

  IBOutlet UIButton *previousPageButton;
  IBOutlet UIButton *nextPageBarButton;
  IBOutlet UILabel *currentPageLabel;
  
  IBOutlet UITableView *myTableView;
  IBOutlet UIActivityIndicatorView *activityIndicator;
 
  BOOL fetching;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *detailViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
