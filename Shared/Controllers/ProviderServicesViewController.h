//
//  ProviderServicesViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 03/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

@class DetailViewController_iPad, ServiceDetailViewController_iPhone;

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

  BOOL currentlyFetchingServices;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *iPhoneDetailViewController;

-(void) updateWithServicesFromProviderWithID:(NSUInteger)providerID;

@end
