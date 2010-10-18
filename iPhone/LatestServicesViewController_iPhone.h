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

@interface LatestServicesViewController_iPhone : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
  NSUInteger currentPage;
  
  NSArray *services;
  NSArray *searchResults;
  
  UITableViewCell *serviceCell;
  
  ServiceDetailViewController_iPhone *detailViewController;

  UINavigationController *navigationController;

  IBOutlet UIButton *previousPageButton;
  IBOutlet UIButton *nextPageBarButton;
  IBOutlet UILabel *currentPageLabel;
  
  NSThread *updateDetailViewControllerThread;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *detailViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
