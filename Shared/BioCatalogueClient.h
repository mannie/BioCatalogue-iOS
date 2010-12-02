//
//  BioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"
#import "JSON+Helper.h"
#import "NSString+Helper.h"


@interface BioCatalogueClient : NSObject {
}

+(BioCatalogueClient *)client;

-(NSURL *) baseURL;
-(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format;

-(NSDictionary *) performSearch:(NSString *)query 
                      withScope:(NSString *)scope
             withRepresentation:(NSString *)format
                           page:(NSUInteger)pageNum;

-(BOOL) serviceIsREST:(NSDictionary *)listingProperties;
-(BOOL) serviceIsSOAP:(NSDictionary *)listingProperties;

-(NSString *) serviceType:(NSDictionary *)listingProperties;

@end
