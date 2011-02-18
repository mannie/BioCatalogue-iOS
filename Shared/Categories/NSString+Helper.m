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
  BOOL isNull = [self isEqual:[NSNull null]] || [self isEqualToString:JSONNull];
  
  NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", @""];
  BOOL isWhiteSpace = [[components filteredArrayUsingPredicate:predicate] count] == 0;
  
  return !isNull && !isWhiteSpace;
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

-(BOOL) isValidEmailAddress {
  /*
   This code was insprired by the DHValidation module by Ben McRedmond;
   http://github.com/benofsky/DHValidation/blob/master/DHValidation.m
   */
  
  NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
  
  return [emailTest evaluateWithObject:self];
} // isValidEmailAddress

-(NSString *) stringByAddingPercentEscapes {
  NSString *processedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  processedString = [processedString stringByReplacingOccurrencesOfString:@"@" withString:@"\%40"];
  return processedString;
} // stringByAddingPercentEscapes


@end
