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
  
  if ([url query] && [format isValidAPIRepresentation]) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@?%@", sanitizedPath, format, [url query]];
  } else if ([url query]) {
    sanitizedPath = [NSString stringWithFormat:@"%@?%@", sanitizedPath, [url query]];
  } else if (format) {
    sanitizedPath = [NSString stringWithFormat:@"%@.%@", sanitizedPath, format];
  }

  return [NSURL URLWithString:sanitizedPath relativeToURL:[BioCatalogueClient baseURL]];
} // URLForPath:withRepresentation

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
    return [WebAccessController documentAtPath:[NSString stringWithFormat:@"/services%@", pathQuery]];
  } else if ([scope isEqualToString:UserResourceScope]) {
    return [WebAccessController documentAtPath:[NSString stringWithFormat:@"/users%@", pathQuery]];
  } else if ([scope isEqualToString:ProviderResourceScope]) {
    return [WebAccessController documentAtPath:[NSString stringWithFormat:@"/service_providers%@", pathQuery]];
  } else {
    return [WebAccessController documentAtPath:[NSString stringWithFormat:@"/search%@", pathQuery]];
  }
} // performSearch:withScope:withRepresentation


#pragma mark -
#pragma mark Attaining Service Types

+(BOOL) serviceIsREST:(NSDictionary *)listingProperties {
  return [[[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:RESTService];
} // serviceIsSOAP

+(BOOL) serviceIsSOAP:(NSDictionary *)listingProperties {
  return [[[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:SOAPService];
} // serviceIsSOAP

+(NSString *) serviceType:(NSDictionary *)listingProperties {
  if ([BioCatalogueClient serviceIsREST:listingProperties]) {
    return RESTService;
  } else if ([BioCatalogueClient serviceIsSOAP:listingProperties]) {
    return SOAPService;
  } else {
    return [[listingProperties objectForKey:JSONTechnologyTypesElement] lastObject];
  }
} // serviceType


@end
