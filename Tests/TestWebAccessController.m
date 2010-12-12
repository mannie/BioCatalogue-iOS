//
//  TestJSON+Helper.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestWebAccessController.h"


@implementation TestWebAccessController


-(void) testGETdocumentAtPath {  
  // ***** non empty documents *****
  NSDictionary *document;
  NSArray *paths = [NSArray arrayWithObjects:@"/api", 
                    @"/services", @"/users", 
                    @"/rest_methods/60", @"/service_providers/1", @"/soap_operations/16551",
                    @"rest_methods?per_page=3&page=5", @"users?per_page=1",
                    @"rest_methods/90/annotations", nil];
  
  for (id path in paths) {
    document = [WebAccessController documentAtPath:path];
    STAssertNotNil(document, [NSString stringWithFormat:@"Document at path '%@' should NOT be nil", path]);
  }
  
  // ***** empty documents *****
  paths = [NSArray arrayWithObjects:@"//", @"/rest_methodss/60", @"rest_methods?page=0", nil];
  for (id path in paths) {
    document = [WebAccessController documentAtPath:path];
    STAssertNil(document, [NSString stringWithFormat:@"Document at path '%@' SHOULD be nil", path]);
  }
}

-(void) testGETLatestServices {
  NSUInteger expected;
  NSArray *latestServices;
  
  for (int i = 0; i < 5; i++) {
    expected = (i + 1) * 3;
    
    latestServices = [WebAccessController latestServices:expected];
    message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
               [latestServices count], expected];
    STAssertEquals(expected, [latestServices count], message);
    
  }

  // should return the default number of services per page
  latestServices = [WebAccessController latestServices:0];
  message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
             [latestServices count], ItemsPerPage];
  STAssertEquals(ItemsPerPage, [latestServices count], message);
}

-(void) testGETServicesAtPage {
  NSUInteger limit = 5;
  
  NSArray *latestServices = [WebAccessController latestServices:limit];
  NSString *latestServicesAsString = [NSString stringWithFormat:@"%@", latestServices];
  
  NSDictionary *services = [[WebAccessController services:limit page:0] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  NSString *servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[WebAccessController services:limit page:1] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=1");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[WebAccessController services:limit page:limit] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page>0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertFalse([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild different documents.");
}


@end

