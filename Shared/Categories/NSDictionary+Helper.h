//
//  NSDictionary+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"


@interface NSDictionary (Helper)

-(BOOL) serviceListingIsRESTService;
-(BOOL) serviceListingIsSOAPService;
-(NSString *) serviceListingType;

@end
