//
//  PaginationDelegate.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PaginationDelegate <NSObject>


#pragma mark -
#pragma mark Services

-(void) performSearch:(NSString *)query 
            withScope:(NSString *)scope
              forPage:(int *)pageNum
             lastPage:(int *)lastPage
             progress:(BOOL *)isBusy 
          resultsData:(NSDictionary **)resultsData  
   performingSelector:(SEL)postFetchActions
             onTarget:(id)target;

-(void) loadSearchResultsForPreviousPage;
-(void) loadSearchResultsForNextPage;


#pragma mark -
#pragma mark Search

-(void) performServiceFetchForPage:(int *)pageNum
                          lastPage:(int *)lastPage
                          progress:(BOOL *)isBusy 
                       resultsData:(NSDictionary **)resultsData
                performingSelector:(SEL)postFetchActions
                          onTarget:(id)target;

-(void) loadServicesOnPreviousPage;
-(void) loadServicesOnNextPage;


@end
