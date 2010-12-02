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

-(void) performServiceFetch {
  [self performServiceFetchForPage:servicesCurrentPage
                          lastPage:servicesLastPage
                          progress:servicesCurrentlyRetrievingData
                       resultsData:servicesResultsData
                performingSelector:servicesPostFetchSelector
                          onTarget:servicesFetchTarget];  
} // performServiceFetch

-(void) performServiceFetchForPage:(int *)pageNum 
                          lastPage:(int *)lastPage
                          progress:(BOOL *)isBusy 
                       resultsData:(NSDictionary **)resultsData
                performingSelector:(SEL)postFetchActions
                          onTarget:(id)target {  
  if ([target respondsToSelector:@selector(startLoadingAnimation)])
    [target performSelector:@selector(startLoadingAnimation)];
  
  servicesCurrentPage = pageNum;
  servicesLastPage = lastPage;
  servicesCurrentlyRetrievingData = isBusy;
  servicesResultsData = resultsData;
  servicesPostFetchSelector = postFetchActions;
  servicesFetchTarget = target;
  
  *isBusy = YES;

  if (*pageNum < 1) *pageNum = 1;
  
  [*resultsData release];
  *resultsData = [[[JSON_Helper helper] services:ServicesPerPage page:*pageNum] retain];
  *lastPage = [[*resultsData objectForKey:JSONPagesElement] intValue];
  
  if (target && postFetchActions) [target performSelector:postFetchActions];
} // performServiceFetchForPage:lastPage:progress:resultsData:performingSelector:onTarget

-(void) loadServicesOnNextPage {
  if (!*servicesCurrentlyRetrievingData) {
    if (*servicesCurrentPage < *servicesLastPage) *servicesCurrentPage += 1;

    [self performServiceFetch];
  }
} // loadServicesOnNextPage

-(void) loadServicesOnPreviousPage {
  if (!*servicesCurrentlyRetrievingData) {
    if (*servicesCurrentPage > 1) {
      *servicesCurrentPage -= 1;
    }
    
    [self performServiceFetch];
  }
} // loadServicesOnPreviousPage


#pragma mark -
#pragma mark Search

-(void) performSearch {
  [self performSearch:searchQuery
            withScope:searchScope
              forPage:searchCurrentPage
             lastPage:searchLastPage
             progress:searchCurrentlyRetrievingData
          resultsData:searchResultsData
   performingSelector:searchPostFetchSelector
             onTarget:searchFetchTarget];  
} // performSearch

-(void) performSearch:(NSString *)query 
            withScope:(NSString *)scope
              forPage:(int *)pageNum
             lastPage:(int *)lastPage
             progress:(BOOL *)isBusy
          resultsData:(NSDictionary **)resultsData 
   performingSelector:(SEL)postFetchActions
             onTarget:(id)target {
  if ([target respondsToSelector:@selector(startLoadingAnimation)]) 
    [target performSelector:@selector(startLoadingAnimation)];

  [searchQuery release];
  searchQuery = [[NSString stringWithString:query] retain];
  
  [searchScope release];
  searchScope = [[NSString stringWithString:scope] retain];
  
  searchCurrentPage = pageNum;
  searchLastPage = lastPage;
  searchCurrentlyRetrievingData = isBusy;
  searchResultsData = resultsData;
  searchPostFetchSelector = postFetchActions;
  searchFetchTarget = target;
  
  *isBusy = YES;
  
  if (*pageNum < 1) *pageNum = 1;
  
  [*resultsData release];
  *resultsData = [[[BioCatalogueClient client] performSearch:query
                                                   withScope:scope
                                          withRepresentation:JSONFormat
                                                        page:*pageNum] retain];
  *lastPage = [[*resultsData objectForKey:JSONPagesElement] intValue];
    
  if (target && postFetchActions) [target performSelector:postFetchActions];
} // performSearch:withScoper:forPage:lastPage:progress:resultsData:performingSelector:onTarget

-(void) loadSearchResultsForNextPage {  
  if (!*searchCurrentlyRetrievingData) {
    if (*searchCurrentPage < *searchLastPage) *searchCurrentPage += 1;

    [self performSearch];
  }
} // loadSearchResultsForNextPage

-(void) loadSearchResultsForPreviousPage {  
  if (!*searchCurrentlyRetrievingData) {
    if (*searchCurrentPage > 1) *searchCurrentPage -= 1;
    
    [self performSearch];
  }
} // loadSearchResultsForPreviousPage


#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
  [*servicesResultsData release];

  [*searchResultsData release];
  [searchQuery release];
  [searchScope release];

  [super dealloc];
} // dealloc


@end
