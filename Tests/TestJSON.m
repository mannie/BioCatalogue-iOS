//
//  TestJSON.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestJSON.h"


@implementation TestJSON

-(void) testGETdocumentAtPath {  
  // ***** non empty documents *****
  NSDictionary *document;
  NSArray *paths = [NSArray arrayWithObjects:@"/api", 
                    @"/services", @"/users", 
                    @"/rest_methods/60", @"/service_providers/1", @"/soap_operations/16551",
                    @"rest_methods?per_page=3&page=5", @"users?per_page=1",
                    @"rest_methods/90/annotations", nil];
  
  for (id path in paths) {
    document = [JSON_Helper documentAtPath:path];
    STAssertNotNil(document, [NSString stringWithFormat:@"Document at path '%@' should NOT be nil", path]);
  }
  
  // ***** empty documents *****
  paths = [NSArray arrayWithObjects:@"//", @"/rest_methodss/60", @"rest_methods?page=0", nil];
  for (id path in paths) {
    document = [JSON_Helper documentAtPath:path];
    STAssertNil(document, [NSString stringWithFormat:@"Document at path '%@' SHOULD be nil", path]);
  }
}

-(void) testGETLatestServices {
  NSUInteger expected;
  NSArray *latestServices;
  
  for (int i = 0; i < 5; i++) {
    expected = (i + 1) * 3;
    
    latestServices = [JSON_Helper latestServices:expected];
    failureMessage = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.", 
                      [latestServices count], expected];
    STAssertEquals(expected, [latestServices count], failureMessage);
    
  }
  // should return the default number of services per page
  latestServices = [JSON_Helper latestServices:0]; 
  failureMessage = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.", 
                    [latestServices count], ServicesPerPage];
  STAssertEquals(ServicesPerPage, [latestServices count], failureMessage);
}

@end
