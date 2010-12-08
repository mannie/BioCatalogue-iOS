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
  IBOutlet UIButton *paginationButtonOne;
  IBOutlet UIButton *paginationButtonTwo;
  IBOutlet UIButton *paginationButtonThree;
  IBOutlet UIButton *paginationButtonFour;
  IBOutlet UIButton *paginationButtonFive;
  IBOutlet UIButton *paginationButtonSix;
  IBOutlet UIButton *paginationButtonSeven;
  
  int *servicesCurrentPage;
  int *servicesLastPage;
  BOOL *servicesCurrentlyRetrievingData;
  NSDictionary **servicesResultsData;
  SEL servicesPostFetchSelector;
  id servicesFetchTarget;

  // search pagination
  NSString *searchQuery;
  NSString *searchScope;
  int *searchCurrentPage;
  int *searchLastPage;
  BOOL *searchCurrentlyRetrievingData;
  NSDictionary **searchResultsData;
  SEL searchPostFetchSelector;
  id searchFetchTarget;
}


-(NSArray *) servicePaginationButtons;
-(IBAction) jumpToServicesOnPage:(UIButton *)sender;
-(void) updateServicePaginationButtons;

-(IBAction) loadServicesOnNextPage;
-(IBAction) loadServicesOnPreviousPage;

-(IBAction) loadSearchResultsForNextPage;
-(IBAction) loadSearchResultsForPreviousPage;

@end
