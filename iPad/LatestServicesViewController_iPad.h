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


@interface LatestServicesViewController_iPad : UITableViewController {
  NSArray *services;

  DetailViewController_iPad *detailViewController;

  NSUInteger currentPage;
  NSUInteger lastPage;

  IBOutlet UILabel *currentPageLabel;
  
  BOOL initializing;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
