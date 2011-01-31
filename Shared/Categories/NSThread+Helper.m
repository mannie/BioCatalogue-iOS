//
//  NSThread+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSThread+Helper.h"


@implementation NSThread (Helper)

+(void) threadExecutionBlock {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [threadTarget performSelector:threadSelector withObject:threadArgument];
  [pool release];
}

+(void) executeSelector:(SEL)selector onTarget:(id)target withObject:(id)argument {
  threadTarget = target;
  threadSelector = selector;
  threadArgument = argument;
  
  [NSThread detachNewThreadSelector:@selector(threadExecutionBlock) toTarget:self withObject:nil];
}

@end
