//
//  PaginationController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BioCatalogueClient.h"
#import "UIDevice+Helper.h"


@interface PaginationController : NSObject {
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

#pragma mark -
#pragma mark Browsing Services

-(NSArray *) servicePaginationButtons;
-(void) updateServicePaginationButtons;

-(BOOL) isCurrentlyFetchingServices;

-(NSArray *) lastFetchedServices;

-(void) performServiceFetch:(int)page 
         performingSelector:(SEL)postFetchActions 
                   onTarget:(id)target;


#pragma mark -
#pragma mark Search

-(NSArray *) searchPaginationButtons;
-(void) updateSearchPaginationButtons;

-(BOOL) isCurrentlyPerformingSearch;

-(NSArray *) lastSearchResults;
-(NSString *) lastSearchQuery;
-(NSString *) lastSearchScope;

-(void) performSearch:(NSString *)query 
            withScope:(NSString *)scope 
                 page:(int)page
   performingSelector:(SEL)postFetchActions
             onTarget:(id)target;

@end
