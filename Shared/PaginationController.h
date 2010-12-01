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


@interface PaginationController : NSObject <PaginationDelegate> {
@private
  int *servicesCurrentPage;
  int *servicesLastPage;
  BOOL *servicesCurrentlyPerformingFetch;
  NSDictionary **servicesResultsData;
  SEL servicesPostFetchSelector;
  id servicesFetchTarget;
}

-(IBAction) loadServicesOnNextPage;
-(IBAction) loadServicesOnPreviousPage;

@end
