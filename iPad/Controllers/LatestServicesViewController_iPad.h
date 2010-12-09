//
//  LatestServicesViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 04/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController_iPad.h"

#import "JSON+Helper.h"
#import "UIView+Helper.h"

#import "PaginationController.h"


@interface LatestServicesViewController_iPad : UITableViewController {
  NSArray *services;

  DetailViewController_iPad *detailViewController;
  
  NSIndexPath *lastSelection;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

@property (nonatomic, retain) IBOutlet PaginationController *paginationController;

@end
