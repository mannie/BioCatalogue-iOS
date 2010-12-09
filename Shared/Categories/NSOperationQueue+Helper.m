//
//  NSOperationQueue+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSOperationQueue+Helper.h"


@implementation NSOperationQueue (Helper)


+(void) addToMainQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object {
  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:target
                                                                          selector:selector
                                                                            object:object];
  [[NSOperationQueue mainQueue] addOperation:operation];
  [operation release];
} // addToMainQueueSelector:toTarget:withObject

+(void) addToCurrentQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object {
  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:target
                                                                          selector:selector
                                                                            object:object];
  [[NSOperationQueue currentQueue] addOperation:operation];
  [operation release];
} // addToCurrentQueueSelector:toTarget:withObject

+(void) addToNewQueueSelector:(SEL)selector toTarget:(id)target withObject:(id)object {
  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:target
                                                                          selector:selector
                                                                            object:object];
  [[NSOperationQueue new] addOperation:operation];
  [operation release];
} // addToNewQueueSelector:toTarget:withObject

@end
