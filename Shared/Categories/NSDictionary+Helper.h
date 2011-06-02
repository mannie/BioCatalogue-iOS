//
//  NSDictionary+Helper.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 14/12/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


@interface NSDictionary (Helper)

-(BOOL) serviceListingIsRESTService;
-(BOOL) serviceListingIsSOAPService;
-(NSString *) serviceListingType;

@end
