//
//  BioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BioCatalogueClient.h"


@implementation BioCatalogueClient

+(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[BioCatalogueClient baseURL]];
  
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

  return [NSURL URLWithString:sanitizedPath relativeToURL:[BioCatalogueClient baseURL]];
} // URLForPath:withRepresentation

+(NSDictionary *) performSearch:(NSString *)query withRepresentation:(NSString *)format {
  if (!query || !format) {
    return nil;
  }
  
  NSString *deURLizedQuery = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  deURLizedQuery = [deURLizedQuery stringByReplacingOccurrencesOfString:@" " withString:@""];
  if ([deURLizedQuery length] == 0) {
    return nil;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] count] > 1) {
    return nil;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]] count] > 1) {
    return nil;
  }
  
  if ([format isEqualToString:JSONFormat]) {
    return [JSON_Helper documentAtPath:[NSString stringWithFormat:@"/search?q=%@", query]];
  } else {
    return nil;
  }
} // performSearch:withRepresentation

@end
