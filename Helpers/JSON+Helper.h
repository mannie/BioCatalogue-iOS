//
//  JSON+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"

#import "BioCatalogueClient.h"
#import "AppConstants.h"


@interface JSON_Helper : NSObject {

}

+(NSDictionary *) documentAtPath:(NSString *)path;

+(NSArray *) latestServices:(NSUInteger)limit;

@end
