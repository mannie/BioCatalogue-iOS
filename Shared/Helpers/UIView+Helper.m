//
//  UIView+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 19/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIView+Helper.h"


@implementation UIView (Helper)


float loadingAnimationDuration = 0.5;


+(void) startAnimatingActivityIndicator:(UIActivityIndicatorView *)activityIndicator dimmingViews:(NSArray *)views {
  [activityIndicator startAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:loadingAnimationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

  for (id view in views) {
    [view setAlpha:0.1];
  }
  
  [UIView commitAnimations];
} // startAnimatingActivityIndicator:dimmingViews

+(void) stopAnimatingActivityIndicator:(UIActivityIndicatorView *)activityIndicator undimmingViews:(NSArray *)views {
  [activityIndicator stopAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:loadingAnimationDuration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

  for (id view in views) {
    [view setAlpha:1];
  }
  
  [UIView commitAnimations];  
} // stopAnimatingActivityIndicator:undimmingViews


@end
