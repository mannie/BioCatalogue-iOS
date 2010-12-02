//
//  NSOperationQueue+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOperationQueue (Helper)

+(void) addToMainQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object;
+(void) addToCurrentQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object;
+(void) addToNewQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object;

@end
