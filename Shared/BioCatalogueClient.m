//
//  BioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueClient.h"


@implementation BioCatalogueClient


static NSString *const OAuthConsumerKey = @"3W1Pq2RQ0wxlAHdt0TCQ";
static NSString *const OAuthConsumerSecret = @"7P9WEKsS50wdX5VDBr5xi3EDzEzHMcv1n0QDRhKc";


#pragma mark -
#pragma mark URLs

+(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

+(NSURL *) announcementsFeedURL {
  NSURL *feedBase = [NSURL URLWithString:[NSString stringWithFormat:@"feed://%@", BioCatalogueHostname]];
  return [feedBase URLByAppendingPathComponent:@"announcements.atom"];
}

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[self baseURL]];
  
  NSString *sanitizedPath = [[url path] lowercaseString];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", JSONFormat] withString:@""];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", BLJSONFormat] withString:@""];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@".%@", XMLFormat] withString:@""];
  
  if ([url query] && [format isValidAPIRepresentation]) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@?%@", sanitizedPath, format, [url query]];
  } else if ([url query]) {
    sanitizedPath = [NSString stringWithFormat:@"%@?%@", sanitizedPath, [url query]];
  } else if (format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@", sanitizedPath, format];
  }
  
  return [NSURL URLWithString:sanitizedPath relativeToURL:[self baseURL]];
} // URLForPath:withRepresentation


#pragma mark -
#pragma mark OAuth Helper URLs

+(NSURL *) OAuthRequestURL {
  return [NSURL URLWithString:@"/oauth/request_token" relativeToURL:[self baseURL]];
} // OAuthRequestURL

+(NSURL *) OAuthAccessURL {
  return [NSURL URLWithString:@"/oauth/access_token" relativeToURL:[self baseURL]];
} // OAuthAccessURL

+(NSURL *) OAuthAuthorizeURL {
  return [NSURL URLWithString:@"/oauth/authorize" relativeToURL:[self baseURL]];
} // OAuthAuthorizeURL

+(NSURL *) OAuthCallbackURL {
  return [self baseURL];
} // OAuthCallbackURL


#pragma mark -
#pragma mark OAuthConsumer

+(GTMOAuthAuthentication *) OAuthAuthentication {  
  GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                             consumerKey:OAuthConsumerKey
                                                                              privateKey:OAuthConsumerSecret];
  
  // setting the service name lets us inspect the auth object later to know what service it is for
  auth.serviceProvider = @"BioCatalogue OAuth Service";
  
  return [auth autorelease];
} // clientOAuthAuthentication

+(void) signInToBioCatalogue {
  
} // signInToBioCatalogue

+(void) signOutOfBioCatalogue {
  [GTMOAuthViewControllerTouch removeParamsFromKeychainForName:OAuthAppServiceName];
} // signOutOfBioCatalogue


#pragma mark -
#pragma mark Web Access

+(NSDictionary *) documentAtPath:(NSString *)path withRepresentation:(NSString *)format {
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
  
  NSError *error = nil;
  NSURLResponse *response = nil;
  
  @try {
    NSURL *url = [self URLForPath:path withRepresentation:format];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:5];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) [error log];
    
    id json = [data objectFromJSONDataWithParseOptions:JKParseOptionUnicodeNewlines|JKParseOptionStrict
                                                 error:&error];
    
    if ([[json allKeys] count] != 1 || [[[json allKeys] lastObject] isEqualToString:JSONErrorsElement]) {
      return nil;
    } else {
      return [json objectForKey:[[json allKeys] lastObject]];
    }
  } @catch (NSException * e) {
    if (error) [error log];
    [e log];

    return nil;
  } @finally {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
  }
} // documentAtPath

+(NSDictionary *) documentAtPath:(NSString *)path {
  return [self documentAtPath:path withRepresentation:JSONFormat];
}

+(NSDictionary *) performSearch:(NSString *)query 
                      withScope:(NSString *)scope
             withRepresentation:(NSString *)format 
                           page:(NSUInteger)pageNum {
  if (![format isValidAPIRepresentation] || ![query isValidQuery]) {
    return nil;
  }
  
  if (pageNum < 1) {
    pageNum = 1;
  }
  
  NSString *pathQuery = [NSString stringWithFormat:@"?q=%@&page=%i&per_page=%i", query, pageNum, ItemsPerPage];
  if ([scope isEqualToString:ServiceResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/services%@", pathQuery]];
  } else if ([scope isEqualToString:UserResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/users%@", pathQuery]];
  } else if ([scope isEqualToString:ProviderResourceScope]) {
    return [self documentAtPath:[NSString stringWithFormat:@"/service_providers%@", pathQuery]];
  } else {
    return [self documentAtPath:[NSString stringWithFormat:@"/search%@", pathQuery]];
  }
} // performSearch:withScope:withRepresentation

+(NSArray *) latestServices:(NSUInteger)limit {
  return [[self services:limit page:1] objectForKey:JSONResultsElement];
} // latestServices

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i", limit, pageNum]];
} // services:page

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum providerID:(NSUInteger)provID {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i&p=[%i]", limit, pageNum, provID]];  
} // services:page:providerID

+(NSDictionary *) monitoringStatusesForServiceWithID:(NSUInteger)serviceID {
  return [self documentAtPath:[NSString stringWithFormat:@"/services/%i/monitoring", serviceID]];  
} // monitoringStatusesForServiceWithID

+(NSDictionary *) providers:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) pageNum = 1;
  if (limit <= 0) limit = ItemsPerPage;
  
  return [self documentAtPath:[NSString stringWithFormat:@"/service_providers?per_page=%i&page=%i", limit, pageNum]];
} // providers:page


@end
