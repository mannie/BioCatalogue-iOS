//
//  BioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"

#import "NSString+Helper.h"
#import "NSError+Helper.h"
#import "NSException+Helper.h"

#import "JSONKit.h"

#import "GTMOAuthViewControllerTouch.h"


@interface BioCatalogueClient : NSObject {
}

+(NSURL *) baseURL;

+(NSURL *) OAuthRequestURL;
+(NSURL *) OAuthAccessURL;
+(NSURL *) OAuthAuthorizeURL;
+(NSURL *) OAuthCallbackURL;

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format;

+(GTMOAuthAuthentication *) clientOAuthAuthentication;

+(NSDictionary *) documentAtPath:(NSString *)path;
+(NSDictionary *) documentAtPath:(NSString *)path withRepresentation:(NSString *)format;

+(NSDictionary *) performSearch:(NSString *)query 
                      withScope:(NSString *)scope
             withRepresentation:(NSString *)format
                           page:(NSUInteger)pageNum;

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum;

+(NSArray *) latestServices:(NSUInteger)limit;

+(NSArray *) BLJSONServicesForPage:(NSUInteger)page;
+(NSArray *) BLJSONProvidersForPage:(NSUInteger)page;
+(NSArray *) BLJSONUsersForPage:(NSUInteger)page;

@end
