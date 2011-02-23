//
//  MyStuffViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 09/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentController.h"
#import "BioCatalogueClient.h"

#import "NSString+Helper.h"
#import "PullToRefreshViewController.h"

#import "DetailViewController_iPad.h"
#import "ServiceDetailViewController_iPhone.h"


@interface MyStuffViewController : PullToRefreshViewController {
  NSMutableArray *userSubmissions;
  NSUInteger lastPageOfUserSubmissions;
  NSUInteger lastLoadedPageOfUserSubmissions;
  NSUInteger activeFetchThreadsForUserSubmissions;
  
  NSUInteger activeUpdateThreads;
  
  NSArray *userFavourites;
  NSArray *userResponsibilities;
    
  NSIndexPath *lastSelectedIndexIPad;

  NSDateFormatter *dateFormatter;
  
  NSUInteger updatedServices;
  
  // iboutlets
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *iPhoneDetailViewController;
@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;

@end
