//
//  BioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"


@interface BioCatalogueClient : NSObject {
  
}

+(NSURL *) baseURL;
+(NSURL *) URLForPath:(NSString *)path withRepresentation:(NSString *)format;

@end
