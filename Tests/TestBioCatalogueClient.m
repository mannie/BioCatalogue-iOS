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


@end
