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


@interface JSON_Helper : NSObject {
}

+(JSON_Helper *) helper;

-(NSDictionary *) documentAtPath:(NSString *)path;

-(NSArray *) latestServices:(NSUInteger)limit;
-(NSArray *) services:(NSUInteger)limit page:(NSUInteger)pageNum;

@end
