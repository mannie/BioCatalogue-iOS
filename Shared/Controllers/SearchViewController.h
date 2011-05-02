//
//  SearchViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 myGrid (University of Manchester). All rights reserved.
//

@class DetailViewController_iPad, UserDetailViewController_iPhone;


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
  ProviderDetailViewController *providerDetailViewController;

  IBOutlet UISearchBar *mySearchBar;  
  
  IBOutlet UILabel *noSearchResultsLabel;
  IBOutlet UIActivityIndicatorView *activityIndicator;
  
  IBOutlet UITableView *dataTableView;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *serviceDetailViewController;
@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController *providerDetailViewController;

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;

@end
