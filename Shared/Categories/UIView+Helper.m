//
//  UIView+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 19/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView+Helper.h"


@implementation UIView (Helper)


#pragma mark -
#pragma mark Helpers

float loadingAnimationDuration = 0.5;

+(void) setUpForAnimation {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:loadingAnimationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];  
}


#pragma mark -
#pragma mark Class Methods

+(void) startLoadingAnimation:(UIActivityIndicatorView *)activityIndicator dimmingViews:(NSArray *)views {
  [activityIndicator startAnimating];
  
  [self setUpForAnimation];
  for (id view in views) {
    [view setAlpha:0.1];
  }
  [UIView commitAnimations];
} // startAnimatingActivityIndicator:dimmingViews

+(void) stopLoadingAnimation:(UIActivityIndicatorView *)activityIndicator undimmingViews:(NSArray *)views {
  [activityIndicator stopAnimating];
  
  [self setUpForAnimation];
  for (id view in views) {
    [view setAlpha:1];
  }
  [UIView commitAnimations];  
} // stopAnimatingActivityIndicator:undimmingViews

+(void) startLoadingAnimation:(UIActivityIndicatorView *)activityIndicator dimmingView:(UIView *)view {
  [activityIndicator startAnimating];
  
  [self setUpForAnimation];
  view.alpha = 0.1;
  [UIView commitAnimations];  
}

+(void) stopLoadingAnimation:(UIActivityIndicatorView *)activityIndicator undimmingView:(UIView *)view {
  [activityIndicator stopAnimating];
  
  [self setUpForAnimation];
  view.alpha = 1;
  [UIView commitAnimations];  
}






#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  
} // dealloc


@end
