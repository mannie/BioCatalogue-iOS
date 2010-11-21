//
//  GestureHandler_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GestureHandler_iPad.h"


@implementation GestureHandler_iPad


float animationDuration = 0.5;


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
          [NSNumber numberWithFloat:point.x], @"x", 
          [NSNumber numberWithFloat:point.y], @"y", nil];
} // dictionaryForCGPoint

-(CGPoint) pointForNSDictionary:(NSDictionary *)point {
  return CGPointMake([[point objectForKey:@"x"] floatValue], [[point objectForKey:@"y"] floatValue]);
} // pointForNSDictionary


#pragma mark -
#pragma mark Handlers

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer {
  BOOL portraitOrientation = [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait;
  CGPoint translation = [recognizer translationInView:recognizer.view];
  
  NSNumber *viewHash = [NSNumber numberWithInt:recognizer.view.hash];
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
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.45];

    NSDictionary *originalCenterAsObject = (portraitOrientation ? 
                                            [initialCenterPositionsInPortrait objectForKey:viewHash] :
                                            [initialCenterPositionsInLandscape objectForKey:viewHash]);
    
    recognizer.view.center = [self pointForNSDictionary:originalCenterAsObject];  
    
    [UIView commitAnimations];
  } // if UIGestureRecognizerStateEnded
} // panViewButResetPositionAfterwards

-(void) rolloutAuxiliaryDetailPanel:(UISwipeGestureRecognizer *)recognizer {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  NSArray *visibleSubviewsInAuxiliaryPanel = [auxiliaryDetailPanel.subviews filteredArrayUsingPredicate:
                                              [NSPredicate predicateWithFormat:@"hidden == NO"]];
  if (!auxiliaryDetailPanelIsExposed && [visibleSubviewsInAuxiliaryPanel count] <= 1) {
    return;
  }
  
  CGPoint center = CGPointMake(auxiliaryDetailPanel.center.x, auxiliaryDetailPanel.center.y);
  CGFloat horizontalShiftOfAuxiliaryDetailPanel = 450; // 480
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft && !auxiliaryDetailPanelIsExposed) {
    center.x -= horizontalShiftOfAuxiliaryDetailPanel;
    auxiliaryDetailPanelIsExposed = YES;
    [self enableInteractionDisablingLayer];
  } 
  
  if (recognizer.direction == UISwipeGestureRecognizerDirectionRight && auxiliaryDetailPanelIsExposed) {
    center.x += horizontalShiftOfAuxiliaryDetailPanel;
    auxiliaryDetailPanelIsExposed = NO;
    [self disableInteractionDisablingLayer:nil];
  }
  
  auxiliaryDetailPanel.center = center;

  [UIView commitAnimations];
  
  [pool drain];
} // rolloutAuxiliaryDetailPanel

-(void) enableInteractionDisablingLayer {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  
  interactionDisablingLayer.alpha = 0.8;
  
  [UIView commitAnimations];
} // enableInteractionDisablingLayer

-(void) disableInteractionDisablingLayer:(UITapGestureRecognizer *)recognizer {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

  if (recognizer) {    
    // create swipe gesture
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] init];
    [NSThread detachNewThreadSelector:@selector(rolloutAuxiliaryDetailPanel:) 
                             toTarget:self 
                           withObject:[swipeRight autorelease]];
  } else {
    interactionDisablingLayer.alpha = 0;
  }

  [UIView commitAnimations];
  
  [pool drain];
} // disableInteractionDisablingLayer


#pragma mark -
#pragma mark Memory Management

-(void) releaseIBOutlets {
  [interactionDisablingLayer release];
  [auxiliaryDetailPanel release];
  
  // default view outlets
  [defaultView release];  
  
  // service view outlets
  [serviceDetailView release];

  // user view outlets  
  [userDetailView release];
  [userDetailIDCardView release];
  
  // provider view outlets
  [providerDetailView release];
  [providerDetailIDCardView release];
} // releaseIBOutlets

-(void) dealloc {
  [self releaseIBOutlets];
  
  [initialCenterPositionsInLandscape release];
  [initialCenterPositionsInPortrait release];
  
  [super dealloc];
} // dealloc


@end
