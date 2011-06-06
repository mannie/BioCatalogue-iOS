//
//  UIDevice+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 29/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation UIDevice (Helper)

-(BOOL) inPortraitOrientation {
  return [self orientation] == UIDeviceOrientationPortrait;
}

-(BOOL) isIPadDevice {
  return [[self model] isEqualToString:@"iPad"] || [[self model] isEqualToString:@"iPad Simulator"];
}

-(BOOL) hasInternetConnection {  
  SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [[[BioCatalogueClient baseURL] host] UTF8String]);
  SCNetworkReachabilityFlags flags;

  Boolean success = SCNetworkReachabilityGetFlags(reachability, &flags);
  Boolean _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
  
  CFRelease(reachability);
  
  return _isDataSourceAvailable;
}

@end
