//
//  BioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueClient.h"


@implementation BioCatalogueClient

+(BioCatalogueClient *) client {
  return [[[BioCatalogueClient alloc] init] autorelease];
}


#pragma mark -
#pragma mark Private Helpers

-(BOOL) validateQuery:(NSString *)query {
  NSString *deURLizedQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  deURLizedQuery = [deURLizedQuery stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  if ([deURLizedQuery length] == 0) {
    return NO;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] count] > 1) {
    return NO;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]] count] > 1) {
    return NO;
  }
  
  return YES;
}


#pragma mark -
#pragma mark Public Helpers

-(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

-(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[self baseURL]];
  
  NSString *sanitizedPath = [[url path] lowercaseString];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".json" withString:@""];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".xml" withString:@""];
  
  if ([url query] && format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@?%@", sanitizedPath, format, [url query]];
  } else if ([url query]) {
    sanitizedPath = [NSString stringWithFormat:@"%@?%@", sanitizedPath, [url query]];
  } else if (format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@", sanitizedPath, format];
  }

  return [NSURL URLWithString:sanitizedPath relativeToURL:[self baseURL]];
} // URLForPath:withRepresentation

-(NSDictionary *) performSearch:(NSString *)query withRepresentation:(NSString *)format {  
  if (!query || !format || ![self validateQuery:query]) {
    return nil;
  }
    
  if ([format isEqualToString:JSONFormat]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/search?q=%@", query]];
  } else {
    return nil;
  }
} // performSearch:withRepresentation

-(NSDictionary *) performSearch:(NSString *)query withScope:(NSString *)scope withRepresentation:(NSString *)format page:(NSUInteger)pageNum {
  if (!query || !format || ![self validateQuery:query]) {
    return nil;
  }
  
  if (pageNum < 1) {
    pageNum = 1;
  }
  
  if ([scope isEqualToString:ServicesSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/services?q=%@&page=%i", query, pageNum]];
  } else if ([scope isEqualToString:UsersSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/users?q=%@&page=%i", query, pageNum]];
  } else if ([scope isEqualToString:ProvidersSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/service_providers?q=%@&page=%i", query, pageNum]];
  } else {
    return [self performSearch:query withRepresentation:format];
  }
} // performSearch:withScope:withRepresentation

@end
