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

@interface LatestServicesViewController_iPhone : UITableViewController {  
  NSArray *services;
    
  ServiceDetailViewController_iPhone *detailViewController;

  UINavigationController *navigationController;

  NSUInteger currentPage;

  IBOutlet UIButton *previousPageButton;
  IBOutlet UIButton *nextPageBarButton;
  IBOutlet UILabel *currentPageLabel;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *detailViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
