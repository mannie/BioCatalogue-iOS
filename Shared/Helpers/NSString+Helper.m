//
//  NSString+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Helper.h"


@implementation NSString (Helper)

-(BOOL) isValidJSONValue {
  BOOL isJSONNull = [self isEqualToString:JSONNull];
  
  NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", @""];
  BOOL isWhiteSpace = [[components filteredArrayUsingPredicate:predicate] count] == 0;
      
  return !isJSONNull && !isWhiteSpace;
}

@end
