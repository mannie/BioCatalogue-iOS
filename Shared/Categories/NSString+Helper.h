//
//  NSString+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface NSString (Helper)

-(BOOL) isValidJSONValue;
-(BOOL) isValidQuery;
-(BOOL) isValidEmailAddress;
-(BOOL) isRegistryName;

-(NSString *) stringByAddingPercentEscapes;
-(NSString *) stringByReformattingJSONDate:(BOOL)includeTime;

@end
