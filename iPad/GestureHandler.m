//
//  GestureHandler.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GestureHandler.h"


@implementation GestureHandler


#pragma mark -
#pragma mark initializer

-(id) init {
  self = [super init];
  
  initialCenterPositionsInLandscape = [[NSMutableDictionary alloc] init];
  initialCenterPositionsInPortrait = [[NSMutableDictionary alloc] init];
  
  return self;
} // init


#pragma mark -
#pragma mark Private Helpers

-(NSDictionary *) dictionaryForCGPoint:(CGPoint)point {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSString stringWithFormat:@"%f", point.x], @"x", 
          [NSString stringWithFormat:@"%f", point.y], @"y", nil];
} // dictionaryForCGPoint

-(CGPoint) pointForNSDictionary:(NSDictionary *)point {
  return CGPointMake([[point objectForKey:@"x"] floatValue], [[point objectForKey:@"y"] floatValue]);
} // pointForNSDictionary


#pragma mark -
#pragma mark Handlers

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer {
  BOOL portraitOrientation = [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait;
  CGPoint translation = [recognizer translationInView:recognizer.view];
  
  NSString *viewHash = [NSString stringWithFormat:@"%i", recognizer.view.hash];
  CGPoint center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y);
  NSDictionary *centerAsObject = [self dictionaryForCGPoint:center];
  
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    BOOL initialCenterNotStoredInLandscape = [initialCenterPositionsInLandscape objectForKey:viewHash] == nil;
    if (!portraitOrientation && initialCenterNotStoredInLandscape) {
      [initialCenterPositionsInLandscape setObject:centerAsObject forKey:viewHash];
    }
    
    BOOL initialCenterNotStoredInPortrait = [initialCenterPositionsInPortrait objectForKey:viewHash] == nil;
    if (portraitOrientation && initialCenterNotStoredInPortrait) {
      [initialCenterPositionsInPortrait setObject:centerAsObject forKey:viewHash];
    }
  } // if UIGestureRecognizerStateBegan
    
  if (recognizer.state == UIGestureRecognizerStateChanged) {
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, 
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
  } // if UIGestureRecognizerStateChanged
  
  if (recognizer.state == UIGestureRecognizerStateEnded) {
    NSDictionary *originalCenterAsObject = (portraitOrientation ? 
                                            [initialCenterPositionsInPortrait objectForKey:viewHash] :
                                            [initialCenterPositionsInLandscape objectForKey:viewHash]);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.45];
    recognizer.view.center = [self pointForNSDictionary:originalCenterAsObject];
    [UIView commitAnimations];
  } // if UIGestureRecognizerStateEnded
} // panViewButResetPositionAfterwards


#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  [initialCenterPositionsInLandscape release];
  [initialCenterPositionsInPortrait release];
  
  [super dealloc];
} // dealloc


@end
