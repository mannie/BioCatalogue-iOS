//
//  NSDictionary+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation NSDictionary (Helper)


-(BOOL) isServiceListingOfType:(NSString *)serviceType {
  for (NSString *technology in [self objectForKey:JSONTechnologyTypesElement]) {
    if ([technology isEqualToString:serviceType]) {
      return YES;
    }
  }
  
  return NO;
} // isServiceListingOfType

-(BOOL) serviceListingIsRESTService {
  return [self isServiceListingOfType:RESTService];
} // serviceListingIsREST

-(BOOL) serviceListingIsSOAPService {
  return [self isServiceListingOfType:SOAPService];
} // serviceListingIsSOAP

-(BOOL) serviceListingIsSoaploabServer {
  return [self isServiceListingOfType:SoaplabServer];
} // serviceListingIsSoaploabServer

-(NSString *) serviceListingType {
  if ([self serviceListingIsRESTService]) {
    return RESTService;
  } else if ([self serviceListingIsSoaploabServer]) {
    return SoaplabServer;
  } else if ([self serviceListingIsSOAPService]) {
    return SOAPService;
  } else {
    return [[self objectForKey:JSONTechnologyTypesElement] lastObject];
  }  
} // serviceListingType


@end
