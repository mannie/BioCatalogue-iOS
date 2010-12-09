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
#pragma mark Browsing Services

-(NSArray *) servicePaginationButtons {
  return [NSArray arrayWithObjects:servicePaginationButtonOne, servicePaginationButtonTwo,
          servicePaginationButtonThree, servicePaginationButtonFour, servicePaginationButtonFive, 
          servicePaginationButtonSix, servicePaginationButtonSeven, nil];
} // servicePaginationButtons

-(void) updateServicePaginationButtons {  
  int firstPageNumber;
  if (serviceCurrentPage <= 4) {
    firstPageNumber = 1;
  } else if (serviceCurrentPage >= serviceLastPage - 3) {
    firstPageNumber = serviceLastPage - 6;
  } else {
    firstPageNumber = serviceCurrentPage - 3;
  }
  
  NSArray *buttons = [self servicePaginationButtons];
  for (int i = 0; i < [buttons count]; i++) {
    int thisPageNumber = firstPageNumber + i;
    
    UIButton *button = [buttons objectAtIndex:i];
    
    [button setTitle:[NSString stringWithFormat:@"%i", thisPageNumber] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    
    [button setEnabled:serviceCurrentPage != thisPageNumber];
    [button setHidden:NO];
  }
} // updateServicePaginationButtons

-(BOOL) isCurrentlyFetchingServices {
  return currentlyRetrievingServiceData;
} // isCurrentlyFetchingServices

-(NSArray *) lastFetchedServices {
  return [NSArray arrayWithArray:[serviceResultsData objectForKey:JSONResultsElement]];
} // lastFetchedServices

-(void) performServiceFetch:(int)page performingSelector:(SEL)postFetchActions onTarget:(id)target {
  serviceCurrentPage = page;
  servicePostFetchSelector = postFetchActions;
  serviceFetchTarget = target;
  
  currentlyRetrievingServiceData = YES;
  
  if (serviceCurrentPage < 1) serviceCurrentPage = 1;
  
  [serviceResultsData release];
  serviceResultsData = [[[JSON_Helper helper] services:ItemsPerPage page:serviceCurrentPage] retain];
  serviceLastPage = [[serviceResultsData objectForKey:JSONPagesElement] intValue];
  
  currentlyRetrievingServiceData = NO;
  
  if (target && postFetchActions) [target performSelector:postFetchActions];
} // performServiceFetch:performingSelector:onTarget

-(void) performServiceFetch {
  [self performServiceFetch:serviceCurrentPage 
         performingSelector:servicePostFetchSelector 
                   onTarget:serviceFetchTarget];
} // performServiceFetch

-(void) jumpToServicesPage:(UIButton *)sender {  
  for (UIButton *button in [self servicePaginationButtons]) {
    button.enabled = NO;
  }
  
  serviceCurrentPage = [sender.titleLabel.text intValue];
  [self updateServicePaginationButtons];
  
  // FIXME: this is not good code; make use of the AnimationController
  if ([[UIDevice currentDevice] isIPadDevice])
    [[((LatestServicesViewController_iPad *)serviceFetchTarget) detailViewController] startLoadingAnimation];
  else
    [serviceFetchTarget performSelector:@selector(startLoadingAnimation)];
  
  [NSOperationQueue addToNewQueueSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // jumpToServicesPage





/*


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
*/

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
  for (id button in [self servicePaginationButtons]) {
    [button release];
  }
  
  [serviceResultsData release];

//  [searchResultsData release];
//  [searchQuery release];
//  [searchScope release];

  [super dealloc];
} // dealloc


@end
