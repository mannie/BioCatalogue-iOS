//
//  PaginationController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PaginationController.h"

#import "LatestServicesViewController_iPad.h"

@implementation PaginationController


#pragma mark -
#pragma mark Helpers

-(NSArray *) servicePaginationButtons {
  return [NSArray arrayWithObjects:paginationButtonOne, paginationButtonTwo, paginationButtonThree, 
          paginationButtonFour, paginationButtonFive, paginationButtonSix, paginationButtonSeven, nil];
} // servicePaginationButtons

-(void) jumpToServicesOnPage:(UIButton *)sender {  
  for (UIButton *button in [self servicePaginationButtons]) {
    button.enabled = NO;
  }
  
  *servicesCurrentPage = [sender.titleLabel.text intValue];
  [self updateServicePaginationButtons];
      
  // FIXME: this is not good code
  if ([[UIDevice currentDevice] isIPadDevice])
    [[((LatestServicesViewController_iPad *)servicesFetchTarget) detailViewController] startLoadingAnimation];
  else
    [servicesFetchTarget performSelector:@selector(startLoadingAnimation)];
  
  [NSOperationQueue addToNewQueueSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // jumpToServicesPage

-(void) updateServicePaginationButtons {  
  int firstPageNumber;
  if (*servicesCurrentPage <= 4) {
    firstPageNumber = 1;
  } else if (*servicesCurrentPage >= *servicesLastPage- 3) {
    firstPageNumber = *servicesLastPage - 6;
  } else {
    firstPageNumber = *servicesCurrentPage - 3;
  }
  
  NSArray *buttons = [self servicePaginationButtons];
  for (int i = 0; i < [buttons count]; i++) {
    int thisPageNumber = firstPageNumber + i;

    UIButton *button = [buttons objectAtIndex:i];

    [button setTitle:[NSString stringWithFormat:@"%i", thisPageNumber] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    
    [button setEnabled:*servicesCurrentPage != thisPageNumber];
    [button setHidden:NO];
      
    [button setNeedsDisplay];
  }
} // updatePaginationButtons:currentPage:lastPage


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
  servicesCurrentPage = pageNum;
  servicesLastPage = lastPage;
  servicesCurrentlyRetrievingData = isBusy;
  servicesResultsData = resultsData;
  servicesPostFetchSelector = postFetchActions;
  servicesFetchTarget = target;
  
  *isBusy = YES;

  if (*pageNum < 1) *pageNum = 1;

  [*resultsData release];
  *resultsData = [[[JSON_Helper helper] services:ItemsPerPage page:*pageNum] retain];
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
  for (id button in [self servicePaginationButtons]) {
    [button release];
  }
  
  [*servicesResultsData release];

  [*searchResultsData release];
  [searchQuery release];
  [searchScope release];

  [super dealloc];
} // dealloc


@end
