//
//  SearchViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BioCatalogueClient.h"

#import "ServiceDetailViewController_iPhone.h"
#import "UserDetailViewController_iPhone.h"
#import "ProviderDetailViewController_iPhone.h"

#import "UIView+Helper.h"


@interface SearchViewController_iPhone : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
  UINavigationController *navigationController;
  
  NSDictionary *searchResultsDocument;
  NSArray *searchResults;
  NSString *searchScope;
  NSString *searchResultsScope;
  
  ServiceDetailViewController_iPhone *serviceDetailViewController;
  UserDetailViewController_iPhone *userDetailViewController;
  ProviderDetailViewController_iPhone *providerDetailViewController;

  NSUInteger currentPage;
  
  IBOutlet UIButton *previousPageButton;
  IBOutlet UIButton *nextPageBarButton;
  IBOutlet UILabel *currentPageLabel;
  
  IBOutlet UISearchBar *mySearchBar;
  IBOutlet UITableView *myTableView;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;

  BOOL performingSearch;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *serviceDetailViewController;
@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController_iPhone *providerDetailViewController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
