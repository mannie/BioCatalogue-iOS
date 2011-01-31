//
//  BioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueClient.h"


@implementation BioCatalogueClient


static NSString *const OAuthConsumerKey = @"akIGZJtdGT0k0QtrzwE8";
static NSString *const OAuthConsumerSecret = @"sqgsA1EFG8NCmVAA1oTndA8vHYaKBTKjSJH87vGb";


#pragma mark -
#pragma mark URLs

+(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

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

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[self baseURL]];
  
  NSString *sanitizedPath = [[url path] lowercaseString];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".json" withString:@""];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".xml" withString:@""];
  
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
#pragma mark OAuthConsumer

+(GTMOAuthAuthentication *) clientOAuthAuthentication {  
  GTMOAuthAuthentication *auth = [[GTMOAuthAuthentication alloc] initWithSignatureMethod:kGTMOAuthSignatureMethodHMAC_SHA1
                                                                             consumerKey:OAuthConsumerKey
                                                                              privateKey:OAuthConsumerSecret];
  
  // setting the service name lets us inspect the auth object later to know what service it is for
  auth.serviceProvider = @"BioCatalogue Auth Service";
  
  return [auth autorelease];
} // clientOAuthAuthentication


#pragma mark -
#pragma mark Web Access

+(NSDictionary *) documentAtPath:(NSString *)path {
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
  
  @try {
    NSError *error = nil;
    NSURLResponse *response;
    
    NSURL *url = [self URLForPath:path withRepresentation:JSONFormat];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:10];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *dataAsString = [[NSString alloc] initWithBytes:[data bytes] 
                                                      length:[data length] 
                                                    encoding:NSUTF8StringEncoding];
    if (error) [error log];
    
    id json = [dataAsString JSONValue];
    [dataAsString release];
    
    if ([[json allKeys] count] != 1 || [[[json allKeys] lastObject] isEqualToString:JSONErrorsElement]) {
      return nil;
    } else {
      NSString *key = [[json allKeys] lastObject];
      return [json objectForKey:key];
    }
  } @catch (NSException * e) {
    NSLog(@"%@\n%@", [e name], [e reason]);
    return nil;
  } @finally {
    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
  }
} // documentAtPath

+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) {
    pageNum = 1;
  }
  
  if (limit <= 0) {
    limit = ItemsPerPage;
  }
  
  return [self documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i&page=%i", limit, pageNum]];
}

+(NSArray *) latestServices:(NSUInteger)limit {
  return [[self services:limit page:1] objectForKey:JSONResultsElement];
} // latestServices

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


@end
