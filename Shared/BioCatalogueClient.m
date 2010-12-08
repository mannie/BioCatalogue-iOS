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
#pragma mark Public Helpers

-(NSURL *) baseURL {
  return [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", BioCatalogueHostname]];
} // baseURL

-(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format {
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

-(NSDictionary *) performSearch:(NSString *)query 
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
  if ([scope isEqualToString:ServicesSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/services%@", pathQuery]];
  } else if ([scope isEqualToString:UsersSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/users%@", pathQuery]];
  } else if ([scope isEqualToString:ProvidersSearchScope]) {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/service_providers%@", pathQuery]];
  } else {
    return [[JSON_Helper helper] documentAtPath:[NSString stringWithFormat:@"/search%@", pathQuery]];
  }
} // performSearch:withScope:withRepresentation


#pragma mark -
#pragma mark Attaining Service Types

-(BOOL) serviceIsREST:(NSDictionary *)listingProperties {
  return [[[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:RESTService];
} // serviceIsSOAP

-(BOOL) serviceIsSOAP:(NSDictionary *)listingProperties {
  return [[[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:SOAPService];
} // serviceIsSOAP

-(NSString *) serviceType:(NSDictionary *)listingProperties {
  if ([self serviceIsREST:listingProperties]) {
    return RESTService;
  } else if ([self serviceIsSOAP:listingProperties]) {
    return SOAPService;
  } else {
    return [[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject];
  }
} // serviceType

@end
