//
//  BrowseByDateViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 myGrid (University of Manchester). All rights reserved.
//

@class DetailViewController_iPad;


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
