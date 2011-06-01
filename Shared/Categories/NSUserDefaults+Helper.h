//
//  NSUserDefaults+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 18/11/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//


@interface NSUserDefaults (Helper)

-(void) serializeLastViewedResource:(NSDictionary *)properties withScope:(NSString *)scope;

@end
