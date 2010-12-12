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

-(void) customizeButton:(UIButton *)button 
                forPage:(int)pageNum
             withAction:(SEL)action
            currentPage:(int)currentPage {
  [button setTitle:[NSString stringWithFormat:@"%i", pageNum] forState:UIControlStateNormal];
  
  [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
  
  [button setEnabled:currentPage != pageNum];
  [button setHidden:NO];
  
  [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
} // customizeButton:forPage:withAction:currentPage


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
    [self customizeButton:[buttons objectAtIndex:i]
                  forPage:firstPageNumber + i
               withAction:@selector(jumpToServicesPage:) 
              currentPage:serviceCurrentPage];
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
  serviceResultsData = [[WebAccessController services:ItemsPerPage page:serviceCurrentPage] retain];
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
  
  dispatch_async(dispatch_queue_create("Fetch services", NULL), ^{
    [self performServiceFetch:serviceCurrentPage 
           performingSelector:servicePostFetchSelector 
                     onTarget:serviceFetchTarget];
  });
} // jumpToServicesPage


#pragma mark -
#pragma mark Search

-(NSArray *) searchPaginationButtons {
  return [NSArray arrayWithObjects:searchPaginationButtonOne, searchPaginationButtonTwo,
          searchPaginationButtonThree, searchPaginationButtonFour, searchPaginationButtonFive, 
          searchPaginationButtonSix, searchPaginationButtonSeven, nil];  
} // searchPaginationButtons

-(void) updateSearchPaginationButtons {
  int firstPageNumber;
  if (searchCurrentPage <= 4) {
    firstPageNumber = 1;
  } else if (searchCurrentPage >= searchLastPage - 3) {
    firstPageNumber = searchLastPage - 6;
  } else {
    firstPageNumber = searchCurrentPage - 3;
  }
  
  NSArray *buttons = [self searchPaginationButtons];
  for (int i = 0; i < [buttons count]; i++) {
    int thisPageNumber = firstPageNumber + i;
    
    if (thisPageNumber > searchLastPage) {
      [[buttons objectAtIndex:i] setHidden:YES];
    } else {
      [self customizeButton:[buttons objectAtIndex:i]
                    forPage:thisPageNumber
                 withAction:@selector(jumpToSearchResultsPage:) 
                currentPage:searchCurrentPage];      
    }
  }  
} // updateSearchPaginationButtons

-(BOOL) isCurrentlyPerformingSearch {
  return currentlyRetrievingSearchData;
} // isCurrentlyPerformingSearch

-(NSArray *) lastSearchResults {
  return [NSArray arrayWithArray:[searchResultsData objectForKey:JSONResultsElement]];
} // lastSearchResults

-(NSString *) lastSearchQuery {
  return [NSString stringWithFormat:@"%@", searchQuery];
} // lastSearchQuery

-(NSString *) lastSearchScope {
  return [NSString stringWithFormat:@"%@", searchScope];
} // lastSearchScope

-(void) performSearch:(NSString *)query 
            withScope:(NSString *)scope 
                 page:(int)page
   performingSelector:(SEL)postFetchActions
             onTarget:(id)target {
  [searchQuery release];
  searchQuery = [[NSString stringWithString:query] copy];
  
  [searchScope release];
  searchScope = [[NSString stringWithString:scope] copy];
  
  searchCurrentPage = page;
  searchPostFetchSelector = postFetchActions;
  searchFetchTarget = target;
  
  currentlyRetrievingSearchData = YES;
  
  if (searchCurrentPage < 1) searchCurrentPage = 1;
  
  [searchResultsData release];
  searchResultsData = [[BioCatalogueClient performSearch:searchQuery
                                               withScope:searchScope
                                      withRepresentation:JSONFormat
                                                    page:searchCurrentPage] retain];
  searchLastPage = [[searchResultsData objectForKey:JSONPagesElement] intValue];
  
  currentlyRetrievingSearchData = YES;
  
  if (target && postFetchActions) [target performSelector:postFetchActions];  
} // performSearch:withScope:page:performingSelector:onTarget

-(void) jumpToSearchResultsPage:(UIButton *)sender {  
  for (UIButton *button in [self searchPaginationButtons]) {
    button.enabled = NO;
  }
  
  searchCurrentPage = [sender.titleLabel.text intValue];
  [self updateSearchPaginationButtons];
  
  // FIXME: this is not good code; make use of the AnimationController
  if ([[UIDevice currentDevice] isIPadDevice])
    [[((LatestServicesViewController_iPad *)searchFetchTarget) detailViewController] startLoadingAnimation];
  else
    [searchFetchTarget performSelector:@selector(startLoadingAnimation)];
  
  dispatch_async(dispatch_queue_create("Search", NULL), ^{
    [self performSearch:searchQuery 
              withScope:searchScope
                   page:searchCurrentPage
     performingSelector:searchPostFetchSelector
               onTarget:searchFetchTarget];
  });
} // jumpToSearchResultsPage


#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  for (id button in [self servicePaginationButtons]) {
    [button release];
  }
  
  [serviceResultsData release];
  
  for (id button in [self searchPaginationButtons]) {
    [button release];
  }
  
  [searchResultsData release];
  [searchQuery release];
  [searchScope release];
  
  [super dealloc];
} // dealloc


@end
