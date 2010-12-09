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

-(void) performSearch:(NSString *)query 
            withScope:(NSString *)scope 
                 page:(int)page
   performingSelector:(SEL)postFetchActions
             onTarget:(id)target;

-(NSArray *) lastSearchResults;
-(NSString *) lastSearchScopeUsed;

-(BOOL) isCurrentlyPerformingSearch;


@end
