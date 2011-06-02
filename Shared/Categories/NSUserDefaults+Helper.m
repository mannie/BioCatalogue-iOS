//
//  NSUserDefaults+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation NSUserDefaults (Helper)


-(id) objectBySanitizingObject:(id)object {
  if ([object isKindOfClass:[NSString class]]) {
    return [NSString stringWithFormat:@"%@", object];
  } else {
    return JSONNull;
  }
} // objectBySanitizingObject

-(NSArray *) arrayBySanitizingArray:(NSArray *)array {
  NSMutableArray *mutableArray = [[NSMutableArray array] retain];
  
  id currentItem;
  for (int i = 0; i < [array count]; i++) {
    currentItem = [array objectAtIndex:i];
    
    if ([currentItem isKindOfClass:[NSDictionary class]]) {
      [mutableArray insertObject:[self dictionaryBySanitizingDictionary:currentItem] atIndex:i];
    } else if ([currentItem isKindOfClass:[NSArray class]]) {
      [mutableArray insertObject:[self arrayBySanitizingArray:currentItem] atIndex:i];
    } else {
      [mutableArray insertObject:[self objectBySanitizingObject:currentItem] atIndex:i];
    }
  }
  
  return [mutableArray autorelease];
} // arrayBySanitizingArray

-(NSDictionary *) dictionaryBySanitizingDictionary:(NSDictionary *)dictionary {
  NSMutableDictionary *mutableDictionary = [[NSMutableDictionary dictionary] retain];
  
  id currentValue;
  for (NSString *key in [dictionary allKeys]) {
    key = [NSString stringWithFormat:@"%@", key];
    currentValue = [dictionary objectForKey:key];
    
    if ([currentValue isKindOfClass:[NSDictionary class]]) {
      [mutableDictionary setObject:[self dictionaryBySanitizingDictionary:currentValue] forKey:key];
    } else if ([currentValue isKindOfClass:[NSArray class]]) {
      [mutableDictionary setObject:[self arrayBySanitizingArray:currentValue] forKey:key];
    } else {
      [mutableDictionary setObject:[self objectBySanitizingObject:currentValue] forKey:key];
    }
  }
  
  return [mutableDictionary autorelease];
} // dictionaryBySanitizingDictionary

-(void) serializeLastViewedResource:(NSDictionary *)properties withScope:(NSString *)scope {
  // FIXME: this is only working for SOME services.  needs to work for ALL
  return;
  
  if ([scope isEqualToString:ServiceResourceScope]) {
    [self setObject:[self dictionaryBySanitizingDictionary:properties] forKey:LastViewedResourceKey];
    [self setObject:scope forKey:LastViewedResourceScopeKey];
  } else if ([scope isEqualToString:AnnouncementResourceScope]) {
    [self setObject:properties forKey:LastViewedResourceKey];
    [self setObject:scope forKey:LastViewedResourceScopeKey];
  }
} // serializeLastViewedResource


@end
