//
//  NSException+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSException+Helper.h"


@implementation NSException (Helper)

-(void) log {
  NSLog(@"%@\n%@\n%@", 
        [self name], 
        [self reason], 
        [self userInfo]);
}

@end
