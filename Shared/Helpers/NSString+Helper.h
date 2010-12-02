//
//  NSString+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"


@interface NSString (Helper)

-(BOOL) isValidJSONValue;
-(BOOL) isValidAPIRepresentation;
-(BOOL) isValidQuery;

@end
