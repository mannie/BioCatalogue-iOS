//
//  NSException+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation NSException (Helper)

-(void) log {
  if ([self name]) {
    NSLog(@"NSExpection: %@\n%@\n%@", [self name], [self reason], [self userInfo]);
  } else if ([self name] && [self reason]) {
    NSLog(@"NSExpection: %@\n%@", [self name], [self reason]);
  } else if ([self name]) {
    NSLog(@"NSExpection: %@", [self name]);
  } else {
    [super log];
  }

}

@end
