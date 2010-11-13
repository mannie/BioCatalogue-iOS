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


@interface SearchViewController_iPad : UITableViewController <UISearchBarDelegate> {
  DetailViewController_iPad *detailViewController;

  NSDictionary *searchResultsDocument;
  NSArray *searchResults;
  NSString *searchScope;
  NSString *searchResultsScope;

  NSUInteger currentPage;
  IBOutlet UILabel *currentPageLabel;
  
  IBOutlet UISearchBar *mySearchBar;
  
  BOOL performingSearch;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *detailViewController;

-(IBAction) loadServicesOnNextPage:(id)sender;
-(IBAction) loadServicesOnPreviousPage:(id)sender;

@end
