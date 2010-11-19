//
//  NSString+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Helper.h"


@implementation NSString (NSString_Helper)

-(BOOL) isValidJSONValue {
  BOOL isEmpty = [[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""];
  BOOL isJSONNull = [self isEqualToString:JSONNull];
  
  if (isEmpty || isJSONNull) {
    return NO;
  }
  
  return YES;
}

@end
