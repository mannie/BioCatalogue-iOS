//
//  NSDictionary+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation NSDictionary (Helper)


-(BOOL) serviceListingIsRESTService {
  return [[[self objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:RESTService];
} // serviceListingIsREST

-(BOOL) serviceListingIsSOAPService {
  return [[[self objectForKey:JSONTechnologyTypesElement] lastObject] isEqualToString:SOAPService];
} // serviceListingIsSOAP

-(NSString *) serviceListingType {
  if ([self serviceListingIsRESTService]) {
    return RESTService;
  } else if ([self serviceListingIsSOAPService]) {
    return SOAPService;
  } else {
    return [[self objectForKey:JSONTechnologyTypesElement] lastObject];
  }  
} // serviceListingType


@end
