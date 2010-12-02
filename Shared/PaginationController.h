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

-(IBAction) loadServicesOnNextPage;
-(IBAction) loadServicesOnPreviousPage;

-(IBAction) loadSearchResultsForNextPage;
-(IBAction) loadSearchResultsForPreviousPage;

@end
