//
//  NSString+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation NSString (Helper)

typedef enum {
  CMJanuary = 1, 
  CMFebruary,
  CMMarch,
  CMApril, 
  CMMay, 
  CMJune,
  CMJuly,
  CMAugust,
  CMSeptember,
  CMOctober,
  CMNovember,
  CMDecember,
} CalendarMonth;

-(NSString *) stringForCalendarMonth:(CalendarMonth)monthNumber {
  switch (monthNumber) {
    case CMJanuary: return @"January";
    case CMFebruary: return @"February";
    case CMMarch: return @"March";
    case CMApril: return @"April";
    case CMMay: return @"May";
    case CMJune: return @"June";
    case CMJuly: return @"July";
    case CMAugust: return @"August";
    case CMSeptember: return @"September";
    case CMOctober: return @"October";
    case CMNovember: return @"November";
    case CMDecember: return @"December";
    default: return @"Unknown month";
  }
}

-(BOOL) isValidJSONValue {
  BOOL isNull = [self isEqual:[NSNull null]] || [self isEqualToString:JSONNull];
  
  NSArray *components = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF != %@", @""];
  BOOL isWhiteSpace = [[components filteredArrayUsingPredicate:predicate] count] == 0;
  
  return !isNull && !isWhiteSpace;
} // isValidJSONValue

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

-(BOOL) isRegistryName {
  NSString *name = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
  BOOL isFeta = [name isEqualToString:@"Feta"];
  BOOL isEMBRACE = [name isEqualToString:@"The EMBRACE Registry"];
  BOOL isSeekDa = [name isEqualToString:@"SeekDa"];
  
  return isFeta || isEMBRACE || isSeekDa;
} // isRegistryName

-(NSString *) stringByAddingPercentEscapes {
  NSString *processedString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  processedString = [processedString stringByReplacingOccurrencesOfString:@"@" withString:@"\%40"];
  return processedString;
} // stringByAddingPercentEscapes

-(NSString *) stringByReformattingJSONDate:(BOOL)includeTime {
  NSArray *dateComponents = [self componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet]];
  
  NSString *time = ([dateComponents count] > 2 ? [dateComponents objectAtIndex:1] : nil);
  
  dateComponents = [[dateComponents objectAtIndex:0] componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]];

  NSString *date = [NSString stringWithFormat:@"%@ %@ %@",
                    [dateComponents lastObject], 
                    [self stringForCalendarMonth:[[dateComponents objectAtIndex:1] intValue]], 
                    [dateComponents objectAtIndex:0]];
  
  if (includeTime && time) {
    return [NSString stringWithFormat:@"%@ at %@", date, time];
  } else {
    return date;
  }
} // stringByReformattingJSONDate

-(NSString *) printableResourceScope {
  if ([self isEqualToString:AnnouncementResourceScope]) {
    return @"Announcement";
  } else if ([self isEqualToString:ServiceResourceScope]) {
    return @"Web Service";
  } else if ([self isEqualToString:UserResourceScope]) {
    return @"User";
  } else {
    return nil;
  }
} // printableBioCatalogueResourceScope

+(NSString *) generateInterestedInMessage:(NSString *)resource withURL:(NSURL *)url {
  return [NSString stringWithFormat:@"This%@ may interest you:\n\n%@\n\n\n", [resource lowercaseString], [url absoluteString]];
}



@end
