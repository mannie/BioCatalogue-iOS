//
//  BioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON+Helper.h"
#import "AppConstants.h"


@interface BioCatalogueClient : NSObject {
  
}

+(NSURL *) baseURL;
+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format;

+(NSDictionary *) performSearch:(NSString *)query withRepresentation:(NSString *)format;
+(NSDictionary *) performSearch:(NSString *)query withScope:(NSString *)scope withRepresentation:(NSString *)format;

@end
