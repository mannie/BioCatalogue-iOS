//
//  TestBioCatalogueBioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestBioCatalogueClient.h"


@implementation TestBioCatalogueClient


-(void) testBaseURL {
  NSString *expected = [NSString stringWithFormat:@"http://%@", BioCatalogueHostname];
  NSString *generated = [[BioCatalogueClient baseURL] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);
}

-(void) testURLForPathWithRepresentation {
  NSString *expected = [NSString stringWithFormat:@"http://%@/api", BioCatalogueHostname];
  NSString *generated = [[BioCatalogueClient URLForPath:@"api" withRepresentation:nil] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [NSString stringWithFormat:@"http://%@/users.json", BioCatalogueHostname];
  generated = [[BioCatalogueClient URLForPath:@"/users" withRepresentation:JSONFormat] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [NSString stringWithFormat:@"http://%@/users.xml?q=mannie", BioCatalogueHostname];
  generated = [[BioCatalogueClient URLForPath:@"/users?q=mannie" withRepresentation:XMLFormat] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [[NSString stringWithFormat:@"http://%@/services?t=[REST]&q=blast", BioCatalogueHostname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  generated = [[BioCatalogueClient URLForPath:@"/services?t=[REST]&q=blast" withRepresentation:nil] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);
}

-(void) testPerformSearchWithScopeAndRepresentationPage {
  // NIL DOCUMENTS
  NSDictionary *results = [BioCatalogueClient performSearch:@"" withScope:UserResourceScope withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [BioCatalogueClient performSearch:@"something" withScope:nil withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [BioCatalogueClient performSearch:@"blast" withScope:@"fake scope" withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [BioCatalogueClient performSearch:@"blast" withScope:UserResourceScope withRepresentation:@"fake format" page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [BioCatalogueClient performSearch:@"franck&tanoh" withScope:UserResourceScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  
  results = [BioCatalogueClient performSearch:@"blast*" withScope:ServiceResourceScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [BioCatalogueClient performSearch:@"e-b+i" withScope:ProviderResourceScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  // NON-NIL DOCUMENTS
  results = [BioCatalogueClient performSearch:@"blast" withScope:@"fake scope" withRepresentation:JSONFormat page:1]; // normal search
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");

  results = [BioCatalogueClient performSearch:@"franck" withScope:UserResourceScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'franck'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
    
  results = [BioCatalogueClient performSearch:@"blast" withScope:ServiceResourceScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
  
  results = [BioCatalogueClient performSearch:@"ebi" withScope:ProviderResourceScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'ebi'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
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
    document = [BioCatalogueClient documentAtPath:path];
    STAssertNotNil(document, [NSString stringWithFormat:@"Document at path '%@' should NOT be nil", path]);
  }
  
  // ***** empty documents *****
  paths = [NSArray arrayWithObjects:@"//", @"/rest_methodss/60", @"rest_methods?page=0", nil];
  for (id path in paths) {
    document = [BioCatalogueClient documentAtPath:path];
    STAssertNil(document, [NSString stringWithFormat:@"Document at path '%@' SHOULD be nil", path]);
  }
}

-(void) testGETLatestServices {
  NSUInteger expected;
  NSArray *latestServices;
  
  for (int i = 0; i < 5; i++) {
    expected = (i + 1) * 3;
    
    latestServices = [BioCatalogueClient latestServices:expected];
    message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
               [latestServices count], expected];
    STAssertEquals(expected, [latestServices count], message);
    
  }
  
  // should return the default number of services per page
  latestServices = [BioCatalogueClient latestServices:0];
  message = [NSString stringWithFormat:@"Retrieved %i latest services.  %i expected.",
             [latestServices count], ItemsPerPage];
  STAssertEquals(ItemsPerPage, [latestServices count], message);
}

-(void) testGETServicesAtPage {
  NSUInteger limit = 5;
  
  NSArray *latestServices = [BioCatalogueClient latestServices:limit];
  NSString *latestServicesAsString = [NSString stringWithFormat:@"%@", latestServices];
  
  NSDictionary *services = [[BioCatalogueClient services:limit page:0] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  NSString *servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[BioCatalogueClient services:limit page:1] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page=1");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertTrue([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild the same document.");
  
  services = [[BioCatalogueClient services:limit page:limit] objectForKey:JSONResultsElement];
  STAssertNotNil(services, @"Services list cannot be nil when page>0");
  STAssertTrue([services count] == limit, [NSString stringWithFormat:@"Found %i", [services count]]);
  servicesAsString = [NSString stringWithFormat:@"%@", services];
  STAssertFalse([servicesAsString isEqualToString:latestServicesAsString], @"Should yeild different documents.");
}


@end
