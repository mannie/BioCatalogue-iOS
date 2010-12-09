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
} // isValidJSONValue

-(BOOL) isValidAPIRepresentation {
  return [self isEqualToString:JSONFormat] || [self isEqualToString:XMLFormat];
} // isValidAPIRepresentation

-(BOOL) isValidQuery {
  NSString *deURLizedQuery = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  deURLizedQuery = [deURLizedQuery stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  if ([deURLizedQuery length] == 0) {
    return NO;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]] count] > 1) {
    return NO;
  }
  
  if ([[deURLizedQuery componentsSeparatedByCharactersInSet:[NSCharacterSet symbolCharacterSet]] count] > 1) {
    return NO;
  }
  
  return YES;  
} // isValidQuery

@end
