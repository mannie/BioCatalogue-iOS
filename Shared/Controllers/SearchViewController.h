//
//  SearchViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ServiceDetailViewController_iPhone.h"
#import "UserDetailViewController_iPhone.h"
#import "ProviderDetailViewController_iPhone.h"

#import "DetailViewController_iPad.h"

#import "NSException+Helper.h"

#import "PullToRefreshViewController.h"
#import "UIContentController.h"


@interface SearchViewController : PullToRefreshViewController <PullToRefreshDataSource, UISearchBarDelegate> {
  NSMutableDictionary *paginatedSearchResults;
  NSString *lastSearchScope;
  NSString *lastSearchQuery;
  
  NSString *currentSearchScope;
  
  NSUInteger lastPage;
  NSUInteger lastLoadedPage;
    
  NSUInteger activeFetchThreads;
  
  NSIndexPath *lastSelectedIndexIPad;  
  
  ServiceDetailViewController_iPhone *serviceDetailViewController;
  UserDetailViewController_iPhone *userDetailViewController;
  ProviderDetailViewController_iPhone *providerDetailViewController;

  IBOutlet UISearchBar *mySearchBar;  
  
  IBOutlet UILabel *noSearchResultsLabel;
  IBOutlet UIActivityIndicatorView *activityIndicator;
  
  IBOutlet UITableView *dataTableView;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *serviceDetailViewController;
@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController_iPhone *providerDetailViewController;

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;

@end
