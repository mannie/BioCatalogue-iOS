//
//  GestureHandler_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation GestureHandler_iPad


NSTimeInterval gestureAnimationDuration = 0.5;


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
  BOOL portraitOrientation = [[UIDevice currentDevice] inPortraitOrientation];
  CGPoint translation = [recognizer translationInView:[recognizer view]];
  
  NSNumber *viewHash = [NSNumber numberWithInt:[[recognizer view] hash]];
  CGPoint center = CGPointMake([[recognizer view] center].x, [[recognizer view] center].y);
  NSDictionary *centerAsObject = [self dictionaryForCGPoint:center];
  
  if ([recognizer state] == UIGestureRecognizerStateBegan) {
    BOOL initialCenterNotStoredInLandscape = [initialCenterPositionsInLandscape objectForKey:viewHash] == nil;
    if (!portraitOrientation && initialCenterNotStoredInLandscape) {
      [initialCenterPositionsInLandscape setObject:centerAsObject forKey:viewHash];
    }
    
    BOOL initialCenterNotStoredInPortrait = [initialCenterPositionsInPortrait objectForKey:viewHash] == nil;
    if (portraitOrientation && initialCenterNotStoredInPortrait) {
      [initialCenterPositionsInPortrait setObject:centerAsObject forKey:viewHash];
    }
  } // if UIGestureRecognizerStateBegan
    
  if ([recognizer state] == UIGestureRecognizerStateChanged) {
    [[recognizer view] setCenter:CGPointMake([[recognizer view] center].x + translation.x, [[recognizer view] center].y + translation.y)];
    [recognizer setTranslation:CGPointZero inView:[recognizer view]];
  } // if UIGestureRecognizerStateChanged
  
  if ([recognizer state] == UIGestureRecognizerStateEnded) {
    NSDictionary *originalCenterAsObject = (portraitOrientation ? 
                                            [initialCenterPositionsInPortrait objectForKey:viewHash] :
                                            [initialCenterPositionsInLandscape objectForKey:viewHash]);  
    
    [UIView animateWithDuration:gestureAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{ [[recognizer view] setCenter:[self pointForNSDictionary:originalCenterAsObject]]; }
                     completion:nil];
  } // if UIGestureRecognizerStateEnded
} // panViewButResetPositionAfterwards

-(void) rolloutAuxiliaryDetailPanel:(UISwipeGestureRecognizer *)recognizer {
  if (!auxiliaryDetailPanelIsExposed && [webBrowser isHidden]) return;
  
  CGPoint center = CGPointMake([auxiliaryDetailPanel center].x, [auxiliaryDetailPanel center].y);
  CGFloat horizontalShiftOfAuxiliaryDetailPanel = 450; // 480
  
  if ([recognizer direction] == UISwipeGestureRecognizerDirectionLeft && !auxiliaryDetailPanelIsExposed) {
    center.x -= horizontalShiftOfAuxiliaryDetailPanel;
    auxiliaryDetailPanelIsExposed = YES;
    [self enableInteractionDisablingLayer];
  } 
  
  if ([recognizer direction] == UISwipeGestureRecognizerDirectionRight && auxiliaryDetailPanelIsExposed) {
    center.x += horizontalShiftOfAuxiliaryDetailPanel;
    auxiliaryDetailPanelIsExposed = NO;
    [self disableInteractionDisablingLayer:nil];
  }

  [UIView animateWithDuration:gestureAnimationDuration
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{ [auxiliaryDetailPanel setCenter:center]; }
                   completion:nil];  
} // rolloutAuxiliaryDetailPanel

-(void) enableInteractionDisablingLayer {
  [UIView animateWithDuration:gestureAnimationDuration
                        delay:0
                      options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                   animations:^{ 
                     [interactionDisablingLayer setAlpha:0.8];
                     [webBrowser setAlpha:1];
                     [webBrowserToolbar setAlpha:1];
                   }
                   completion:nil];  
} // enableInteractionDisablingLayer

-(void) disableInteractionDisablingLayer:(UITapGestureRecognizer *)recognizer {
  if (recognizer) {    
    // create swipe gesture
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] init];
    [self rolloutAuxiliaryDetailPanel:[swipeRight autorelease]];
  } else {
    [UIView animateWithDuration:gestureAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ 
                       [interactionDisablingLayer setAlpha:0];
                       [webBrowser setAlpha:0];
                       [webBrowserToolbar setAlpha:0];
                     }
                     completion:nil];
  }
} // disableInteractionDisablingLayer


#pragma mark -
#pragma mark Memory Management

-(void) releaseIBOutlets {
  [interactionDisablingLayer release];
  [auxiliaryDetailPanel release];

  [webBrowserToolbar release];
  [webBrowser release];
  
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
