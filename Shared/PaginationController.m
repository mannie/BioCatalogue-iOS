//
//  PaginationController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PaginationController.h"


@implementation PaginationController


#pragma mark -
#pragma mark Services

-(void) performServiceFetchForPage:(int *)pageNum 
                          lastPage:(int *)lastPage
                          progress:(BOOL *)isBusy 
                       resultsData:(NSDictionary **)resultsData
                performingSelector:(SEL)postFetchActions
                          onTarget:(id)target {
  if ([target respondsToSelector:@selector(startLoadingAnimation)]) {
//    [target performSelectorInBackground:@selector(startLoadingAnimation) withObject:nil];
    [target performSelector:@selector(startLoadingAnimation)];
  }
  
  servicesCurrentPage = pageNum;
  servicesLastPage = lastPage;
  servicesCurrentlyPerformingFetch = isBusy;
  servicesResultsData = resultsData;
  servicesPostFetchSelector = postFetchActions;
  servicesFetchTarget = target;
  
  *isBusy = YES;
  
  if (*pageNum < 1) {
    *pageNum = 1;
  }
  
  [*resultsData release];
  *resultsData = [[[JSON_Helper helper] services:ServicesPerPage page:*pageNum] retain];
  *lastPage = [[*resultsData objectForKey:JSONPagesElement] intValue];

  *isBusy = NO;
  
  if (target && postFetchActions) {
    [target performSelector:postFetchActions];
  } 
  
  if ([target respondsToSelector:@selector(stopLoadingAnimation)]) {
//    [target performSelectorInBackground:@selector(stopLoadingAnimation) withObject:nil];
    [target performSelector:@selector(stopLoadingAnimation)];
  }
} // performServiceFetchForPage:lastPage:progress:resultsData:performingSelector:onTarget

-(void) loadServicesOnNextPage {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
  if (!*servicesCurrentlyPerformingFetch) {
    if (*servicesCurrentPage < *servicesLastPage) {
      *servicesCurrentPage += 1;
    }

    [self performServiceFetchForPage:servicesCurrentPage
                            lastPage:servicesLastPage
                            progress:servicesCurrentlyPerformingFetch
                         resultsData:servicesResultsData
                  performingSelector:servicesPostFetchSelector
                            onTarget:servicesFetchTarget];    
  }

  [autoreleasePool drain];
} // loadServicesOnNextPage

-(void) loadServicesOnPreviousPage {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

  if (!*servicesCurrentlyPerformingFetch) {
    if (*servicesCurrentPage > 1) {
      *servicesCurrentPage -= 1;
    }
    
    [self performServiceFetchForPage:servicesCurrentPage
                            lastPage:servicesLastPage
                            progress:servicesCurrentlyPerformingFetch
                         resultsData:servicesResultsData
                  performingSelector:servicesPostFetchSelector
                            onTarget:servicesFetchTarget];    
  }

  [autoreleasePool drain];
} // loadServicesOnPreviousPage

#pragma mark -
#pragma mark Search



#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
  [super dealloc];
} // dealloc


@end
