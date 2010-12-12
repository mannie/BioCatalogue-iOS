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

#import "PaginationController.h"


@interface SearchViewController_iPhone : UITableViewController <UISearchBarDelegate> {
  NSArray *searchResults;
  NSString *searchScope;
  
  ServiceDetailViewController_iPhone *serviceDetailViewController;
  UserDetailViewController_iPhone *userDetailViewController;
  ProviderDetailViewController_iPhone *providerDetailViewController;
  
  IBOutlet UISearchBar *mySearchBar;  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet ServiceDetailViewController_iPhone *serviceDetailViewController;
@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController_iPhone *providerDetailViewController;

@property (nonatomic, retain) IBOutlet PaginationController *paginationController;

@end
