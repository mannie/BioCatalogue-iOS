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
}

+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
  NSURL *url = [NSURL URLWithString:path relativeToURL:[BioCatalogueClient baseURL]];
  
  NSString *sanitizedPath = [[url path] lowercaseString];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".json" withString:@""];
  sanitizedPath = [sanitizedPath stringByReplacingOccurrencesOfString:@".xml" withString:@""];
  sanitizedPath = [NSString stringWithFormat:@"%@.%@?%@", sanitizedPath, format, [url query]];
  
  return [NSURL URLWithString:sanitizedPath relativeToURL:[BioCatalogueClient baseURL]];
}

@end
