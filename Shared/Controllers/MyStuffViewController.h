//
//  MyStuffViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 09/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

@class DetailViewController_iPad;


@interface MyStuffViewController : PullToRefreshViewController {
  NSMutableArray *userSubmissions;
  NSUInteger lastPageOfUserSubmissions;
  NSUInteger lastLoadedPageOfUserSubmissions;
  NSUInteger activeFetchThreadsForUserSubmissions;
    
  NSArray *userFavourites;
  NSArray *userResponsibilities;
    
  NSIndexPath *lastSelectedIndexIPad;
  
  // iboutlets
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *iPhoneDetailViewController;
@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;


@end
