//
//  BrowseByProviderViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface BrowseByProviderViewController : PullToRefreshViewController <PullToRefreshDataSource> {
  NSMutableDictionary *paginatedProviders;
  
  NSUInteger lastPage;
  NSUInteger lastLoadedPage;
  
  NSUInteger activeFetchThreads;
  
  ProviderDetailViewController *providerDetailViewController;
  
  NSIndexPath *lastSelectedIndexIPad;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ProviderDetailViewController *providerDetailViewController;

@end
