//
//  TestBioCatalogueClient.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TestBioCatalogueClient.h"


@implementation TestBioCatalogueClient

-(void) setUp {
  client = [[BioCatalogueClient alloc] init];
}

-(void) testBaseURL {
  NSString *expected = [NSString stringWithFormat:@"http://%@", BioCatalogueHostname];
  NSString *generated = [[client baseURL] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);
}

-(void) testURLForPathWithRepresentation {
  NSString *expected = [NSString stringWithFormat:@"http://%@/api", BioCatalogueHostname];
  NSString *generated = [[client URLForPath:@"api" withRepresentation:nil] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [NSString stringWithFormat:@"http://%@/users.json", BioCatalogueHostname];
  generated = [[client URLForPath:@"/users" withRepresentation:JSONFormat] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [NSString stringWithFormat:@"http://%@/users.xml?q=mannie", BioCatalogueHostname];
  generated = [[client URLForPath:@"/users?q=mannie" withRepresentation:XMLFormat] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);

  expected = [[NSString stringWithFormat:@"http://%@/services?t=[REST]&q=blast", BioCatalogueHostname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  generated = [[client URLForPath:@"/services?t=[REST]&q=blast" withRepresentation:nil] absoluteString];
  message = [NSString stringWithFormat:@"Found '%@' but was expecting '%@'", generated, expected];
  STAssertTrue([generated isEqualToString:expected], message);
}

-(void) testPerformSearchWithScopeAndRepresentationPage {
  // NIL DOCUMENTS
  NSDictionary *results = [client performSearch:@"" withScope:UsersSearchScope withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"something" withScope:nil withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"blast" withScope:@"fake scope" withRepresentation:nil page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"blast" withScope:UsersSearchScope withRepresentation:@"fake format" page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"franck&tanoh" withScope:UsersSearchScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  
  results = [client performSearch:@"blast*" withScope:ServicesSearchScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"e-b+i" withScope:ProvidersSearchScope withRepresentation:JSONFormat page:1];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  // NON-NIL DOCUMENTS
  results = [client performSearch:@"blast" withScope:@"fake scope" withRepresentation:JSONFormat page:1]; // normal search
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");

  results = [client performSearch:@"franck" withScope:UsersSearchScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'franck'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
    
  results = [client performSearch:@"blast" withScope:ServicesSearchScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
  
  results = [client performSearch:@"ebi" withScope:ProvidersSearchScope withRepresentation:JSONFormat page:1];
  STAssertNotNil(results, @"nil JSON document returned for 'ebi'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
}

-(void) tearDown {
  [client release];
}

@end
