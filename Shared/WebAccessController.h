//
//  JSON+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"

#import "AppConstants.h"
#import "BioCatalogueClient.h"


@interface WebAccessController : NSObject {
  
}

+(NSDictionary *) documentAtPath:(NSString *)path;
+(NSDictionary *) services:(NSUInteger)limit page:(NSUInteger)pageNum;

+(NSArray *) latestServices:(NSUInteger)limit;

@end
