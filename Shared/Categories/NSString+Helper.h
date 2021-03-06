//
//  NSString+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


@interface NSString (Helper)

-(BOOL) isValidJSONValue;
-(BOOL) isValidQuery;
-(BOOL) isValidEmailAddress;
-(BOOL) isRegistryName;

-(NSString *) stringByAddingPercentEscapes;
-(NSString *) stringByReformattingJSONDate:(BOOL)includeTime;

-(NSString *) printableResourceScope;

+(NSString *) generateInterestedInMessage:(NSString *)resource withURL:(NSURL *)url;

@end
