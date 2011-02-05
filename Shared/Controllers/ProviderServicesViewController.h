//
//  ProviderServicesViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"

#import "UIContentController.h"
#import "BioCatalogueClient.h"

#import "DetailViewController_iPad.h"

#import "NSException+Helper.h"

#import "AppDelegate_iPad.h"
#import "DetailViewController_iPad.h"

@class ServiceDetailViewController_iPhone;


@interface ProviderServicesViewController : UITableViewController {
  NSUInteger currentProviderID;
  
  NSMutableDictionary *paginatedServices;
  
  NSUInteger lastPage;
  NSUInteger lastLoadedPage;
  
  NSUInteger activeFetchThreads;
  
  ServiceDetailViewController_iPhone *iPhoneDetailViewController;
  DetailViewController_iPad *iPadDetailViewController;
  
  NSIndexPath *lastSelectedIndexIPad;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
  IBOutlet UILabel *noServicesLabel;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *iPhoneDetailViewController;

-(void) updateWithServicesFromProviderWithID:(NSUInteger)providerID;

@end
