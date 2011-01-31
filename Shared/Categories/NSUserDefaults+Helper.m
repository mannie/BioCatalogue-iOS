//
//  NSUserDefaults+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSUserDefaults+Helper.h"


@implementation NSUserDefaults (Helper)

-(void) serializeLastViewedResource:(NSDictionary *)properties withScope:(NSString *)scope {
  // FIXME: this was broken as a result of using the JSONKit parsing framework instead of SBJson
  
/*
  NSMutableDictionary *mutableProperties = [properties mutableCopy];
  id value;
  
  NSMutableDictionary *mutableSubProperties;
  NSString *subValue;
  
  for (NSString *key in [mutableProperties allKeys]) {
    value = [mutableProperties objectForKey:key];
    
    if ([value isKindOfClass:[NSDictionary class]]) { // thing is a dictionary
      mutableSubProperties = [value mutableCopy];
      
      for (NSString *subKey in [mutableSubProperties allKeys]) {
        subValue = [NSString stringWithFormat:@"%@", [mutableSubProperties objectForKey:subKey]];
        if (![subValue isValidJSONValue]) {
          [mutableSubProperties setObject:@"" forKey:subKey];
        }        
      } // for each key
      
      [mutableProperties setObject:mutableSubProperties forKey:key];
      [mutableSubProperties release];
    } else { // this is not a dictionary
      value = [NSString stringWithFormat:@"%@", [mutableProperties objectForKey:key]];
      if (![value isValidJSONValue]) {
        [mutableProperties setObject:@"" forKey:key];
      }
    } // if else dictionary
  } // for each key

  [self setObject:mutableProperties forKey:LastViewedResourceKey];
  [self setObject:scope forKey:LastViewedResourceScopeKey];

  [mutableProperties release];
*/
} // serializeLastViewedResource

@end
