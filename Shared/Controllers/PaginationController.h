//
//  PaginationController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaginationDelegate.h"

#import "JSON+Helper.h"
#import "UIDevice+Helper.h"
#import "NSOperationQueue+Helper.h"


@interface PaginationController : NSObject <PaginationDelegate> {
  // services pagination
  IBOutlet UIButton *servicePaginationButtonOne;
  IBOutlet UIButton *servicePaginationButtonTwo;
  IBOutlet UIButton *servicePaginationButtonThree;
  IBOutlet UIButton *servicePaginationButtonFour;
  IBOutlet UIButton *servicePaginationButtonFive;
  IBOutlet UIButton *servicePaginationButtonSix;
  IBOutlet UIButton *servicePaginationButtonSeven;
  
  int serviceCurrentPage;
  int serviceLastPage;
  BOOL currentlyRetrievingServiceData;
  NSDictionary *serviceResultsData;
  SEL servicePostFetchSelector;
  id serviceFetchTarget;
  
  // search pagination
  IBOutlet UIButton *searchPaginationButtonOne;
  IBOutlet UIButton *searchPaginationButtonTwo;
  IBOutlet UIButton *searchPaginationButtonThree;
  IBOutlet UIButton *searchPaginationButtonFour;
  IBOutlet UIButton *searchPaginationButtonFive;
  IBOutlet UIButton *searchPaginationButtonSix;
  IBOutlet UIButton *searchPaginationButtonSeven;

  NSString *searchQuery;
  NSString *searchScope;
  
  int searchCurrentPage;
  int searchLastPage;
  BOOL currentlyRetrievingSearchData;
  NSDictionary *searchResultsData;
  SEL searchPostFetchSelector;
  id searchFetchTarget;
}


@end
