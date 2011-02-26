//
//  UIDevice+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation UIDevice (Helper)

-(BOOL) inPortraitOrientation {
  return [self orientation] == UIDeviceOrientationPortrait;
}

-(BOOL) isIPadDevice {
  return [[self model] isEqualToString:@"iPad"] || [[self model] isEqualToString:@"iPad Simulator"];
}

@end
