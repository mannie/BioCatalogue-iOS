//
//  NSThread+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSThread (Helper)

static id threadTarget;
static SEL threadSelector;
static id threadArgument;

+(void) executeSelector:(SEL)selector onTarget:(id)target withObject:(id)argument;

@end
