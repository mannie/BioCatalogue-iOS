//
//  NSError+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation NSError (Helper)

-(void) log {
  [[NSNotificationCenter defaultCenter] postNotificationName:ErrorOccurred object:self];
  
  if ([self localizedDescription] && [self localizedFailureReason] && [self localizedRecoverySuggestion]) {
    NSLog(@"NSError: %@\n%@\n%@", [self localizedDescription], [self localizedFailureReason], [self localizedRecoverySuggestion]);    
  } else if ([self localizedDescription] && [self localizedFailureReason]) {
    NSLog(@"NSError: %@\n%@", [self localizedDescription], [self localizedFailureReason]);    
  } else if ([self localizedDescription]) {
    NSLog(@"NSError: %@", [self localizedDescription]);    
  } else {
    [super log];
  }
}

@end
