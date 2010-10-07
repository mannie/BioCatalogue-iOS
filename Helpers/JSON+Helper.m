//
//  JSON+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSON+Helper.h"


@implementation JSON_Helper

+(NSDictionary *) documentAtPath:(NSString *)path {
  NSError *error;
  
  NSURL *url = [BioCatalogueClient URLForPath:path withRepresentation:JSONFormat];

  NSString *jsonResponse = [NSString stringWithContentsOfURL:url
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
  
  if ([[[jsonResponse JSONValue] allKeys] count] != 1) {
    return nil;
  } else {
    NSString *key = [[[jsonResponse JSONValue] allKeys] lastObject];
    return [[jsonResponse JSONValue] objectForKey:key];
  }  
} // documentAtPath

+(NSArray *) latestServices:(NSUInteger)limit {
  if (limit <= 0) {
    limit = ServicesPerPage;
  }
  
  NSDictionary *document = [JSON_Helper documentAtPath:[NSString stringWithFormat:@"/services?per_page=%i", limit]];
  return [document objectForKey:ResultsKey];
} // latestServices

@end
