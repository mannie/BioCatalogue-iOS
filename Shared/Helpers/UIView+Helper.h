//
//  UIView+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 19/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (Helper)

+(void) startLoadingAnimation:(UIActivityIndicatorView *)activityIndicator dimmingViews:(NSArray *)views;
+(void) stopLoadingAnimation:(UIActivityIndicatorView *)activityIndicator undimmingViews:(NSArray *)views;

+(void) startLoadingAnimation:(UIActivityIndicatorView *)activityIndicator dimmingView:(UIView *)view;
+(void) stopLoadingAnimation:(UIActivityIndicatorView *)activityIndicator undimmingView:(UIView *)view;

@end
