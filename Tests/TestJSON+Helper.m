//
//  TestJSON+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestJSON+Helper.h"


@implementation TestJSON_Helper

-(void) setUp {
  jsonHelper = [[JSON_Helper helper] retain];
}

-(void) testGETdocumentAtPath {  
  // ***** non empty documents *****
  NSDictionary *document;
  NSArray *paths = [NSArray arrayWithObjects:@"/api", 
                    @"/services", @"/users", 
                    @"/rest_methods/60", @"/service_providers/1", @"/soap_operations/16551",
                    @"rest_methods?per_page=3&page=5", @"users?per_page=1",
                    @"rest_methods/90/annotations", nil];
  
  for (id path in paths) {
    document = [jsonHelper documentAtPath:path];
    STAssertNotNil(document, [NSString stringWithFormat:@"Document at path '%@' should NOT be nil", path]);
  }
  
  // ***** empty documents *****
  paths = [NSArray arrayWithObjects:@"//", @"/rest_methodss/60", @"rest_methods?page=0", nil];
  for (id path in paths) {
    document = [jsonHelper documentAtPath:path];
    STAssertNil(document, [NSString stringWithFormat:@"Document at path '%@' SHOULD be nil", path]);
  }
}

-(void) testGETLatestServices {
  NSUInteger expected;
  NSArray *latestServices;
  
  for (int i = 0; i < 5; i++) {
    expected = (i + 1) * 3;
    
    latestServices = [jsonHelper latestServices:expected];
    message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
               [latestServices count], expected];
    STAssertEquals(expected, [latestServices count], message);
    
  }

  // should return the default number of services per page
  latestServices = [jsonHelper latestServices:0]; 
  message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
             [latestServices count], ServicesPerPage];
  STAssertEquals(ServicesPerPage, [latestServices count], message);
}

-(void) testGETServicesAtPage {
  NSUInteger limit = 5;
  
  NSArray *latestServices = [jsonHelper latestServices:limit];
  NSString *latestServicesAsString = [NSString stringWithFormat:@"%@", latestServices];
  
  NSDictionary *services = [[jsonHelper services:limit page:0] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  NSString *servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[jsonHelper services:limit page:1] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=1");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[jsonHelper services:limit page:limit] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page>0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertFalse([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild different documents.");
}

-(void) tearDown {
  [jsonHelper release];
}

@end

