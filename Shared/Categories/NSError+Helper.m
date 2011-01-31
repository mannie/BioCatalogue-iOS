//
//  NSError+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSError+Helper.h"


@implementation NSError (Helper)

-(void) log {
  NSLog(@"%@\n%@\n%@", 
        [self localizedDescription], 
        [self localizedFailureReason], 
        [self localizedRecoverySuggestion]);
}

@end
