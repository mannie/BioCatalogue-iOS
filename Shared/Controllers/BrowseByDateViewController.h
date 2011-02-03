//
//  BrowseByDateViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshViewController.h"
#import "UIContentController.h"

#import "ServiceDetailViewController_iPhone.h"
#import "DetailViewController_iPad.h"

#import "NSException+Helper.h"


@interface BrowseByDateViewController : PullToRefreshViewController <PullToRefreshDataSource> {
  NSMutableDictionary *paginatedServices;
  
  NSUInteger lastPage;
  NSUInteger lastLoadedPage;
    
  NSUInteger activeFetchThreads;

  ServiceDetailViewController_iPhone *iPhoneDetailViewController;
  DetailViewController_iPad *iPadDetailViewController;
  
  NSIndexPath *lastSelectedIndexIPad;

  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *iPhoneDetailViewController;
@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;

@end
