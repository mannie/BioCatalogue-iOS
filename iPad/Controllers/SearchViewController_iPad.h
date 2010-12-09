//
//  SearchViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController_iPad.h"
#import "BioCatalogueClient.h"

#import "UIView+Helper.h"

#import "PaginationController.h"


@interface SearchViewController_iPad : UITableViewController <UISearchBarDelegate> {
  DetailViewController_iPad *detailViewController;

  NSDictionary *searchResultsDocument;
  NSArray *searchResults;
  NSString *searchScope;
  NSString *searchResultsScope;

  int currentPage;
  int lastPage;

  IBOutlet UILabel *currentPageLabel;
  
  IBOutlet UISearchBar *mySearchBar;
  
  BOOL performingSearch;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

@property (nonatomic, retain) IBOutlet PaginationController *paginationController;

@end
