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
  @try {
    NSError *error;
    NSURLResponse *response;
    
    NSURL *url = [[BioCatalogueClient client] URLForPath:path withRepresentation:JSONFormat];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:10];

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *dataAsString = [[NSString alloc] initWithBytes:[data bytes] 
                                                      length:[data length] 
                                                    encoding:NSUTF8StringEncoding];
        
    id json = [dataAsString JSONValue];
    [dataAsString release];
    
    if ([[json allKeys] count] != 1) {
      return nil;
    } else {
      NSString *key = [[json allKeys] lastObject];
      return [json objectForKey:key];
    }
  } @catch (NSException * e) {
    return nil;
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


@end
