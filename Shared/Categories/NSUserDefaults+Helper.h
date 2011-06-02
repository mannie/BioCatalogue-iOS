//
//  NSUserDefaults+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


@interface NSUserDefaults (Helper)

-(NSDictionary *) dictionaryBySanitizingDictionary:(NSDictionary *)dictionary;

-(void) serializeLastViewedResource:(NSDictionary *)properties withScope:(NSString *)scope;

@end
