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
  NSError *error = nil;
  
  NSString *path = [NSString stringWithFormat:@"/%@?per_page=1", InternetConnectionTestResourceScope];
  NSURL *url = [BioCatalogueClient URLForPath:path withRepresentation:JSONFormat];
  NSURLRequest *request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestReloadRevalidatingCacheData 
                                       timeoutInterval:APIRequestTimeout];
  [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
  
  return error == nil;
}

@end
