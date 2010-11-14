//
//  JSON+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "JSON+Helper.h"


@implementation JSON_Helper

+(JSON_Helper *) helper {
  return [[[JSON_Helper alloc] init] autorelease];
}

#pragma mark -
#pragma mark Helpers

-(NSDictionary *) documentAtPath:(NSString *)path {
  NSError *error;
  
  NSURL *url = [[BioCatalogueClient client] URLForPath:path withRepresentation:JSONFormat];
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

-(NSArray *) latestServices:(NSUInteger)limit {
  return [self services:limit page:1];
} // latestServices

-(NSArray *) services:(NSUInteger)limit page:(NSUInteger)pageNum {
  if (pageNum < 1) {
    pageNum = 1;
  }

  if (limit <= 0) {
    limit = ServicesPerPage;
  }
  
  NSDictionary *document = [self documentAtPath:
                            [NSString stringWithFormat:@"/services?per_page=%i&page=%i", limit, pageNum]];
  return [document objectForKey:JSONResultsElement];
}


#pragma mark -
#pragma mark NSURLConnection delegate

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  NSLog(@"%@ - %@", connection, response);
}

@end
