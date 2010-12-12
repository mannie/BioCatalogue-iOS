//
//  JSON+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebAccessController.h"


@implementation WebAccessController


+(NSDictionary *) documentAtPath:(NSString *)path {
  @try {
    NSError *error = nil;
    NSURLResponse *response;
    
    NSURL *url = [BioCatalogueClient URLForPath:path withRepresentation:JSONFormat];
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                         timeoutInterval:10];

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *dataAsString = [[NSString alloc] initWithBytes:[data bytes] 
                                                      length:[data length] 
                                                    encoding:NSUTF8StringEncoding];
    
    if (error) {
      NSLog(@"%@\n%@\n%@", [error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
    }
    
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


@end
