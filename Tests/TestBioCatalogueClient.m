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

-(void) testPerformSearchWithRepresentation {
  NSDictionary *results = [client performSearch:@"" withRepresentation:nil];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"blast" withRepresentation:nil];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"search?q=blast" withRepresentation:JSONFormat];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"blast&scope=services" withRepresentation:JSONFormat];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"blast" withRepresentation:JSONFormat];
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 3, @"Incorrect results count yeiled.");

/*
  search = [client performSearch:@"blast" withRepresentation:XMLFormat];
  STAssertNotNil(search, @"nil XML document returned for 'blast'");
  STAssertTrue([[search objectForKey:JSONResultsElement] count] > 3, @"Incorrect results count yeiled.");
*/
}

-(void) testPerformSearchWithScopeAndRepresentation {
  NSDictionary *results = [client performSearch:@"" withScope:nil withRepresentation:nil];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"blast" withScope:nil withRepresentation:nil];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);

  results = [client performSearch:@"blast" withScope:nil withRepresentation:JSONFormat];
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([results count] == [[client performSearch:@"blast" withRepresentation:JSONFormat] count], 
               @"Incorrect results count yeiled.");
  
  results = [client performSearch:@"franck" withScope:UsersSearchScope withRepresentation:JSONFormat];
  STAssertNotNil(results, @"nil JSON document returned for 'franck'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
  
  results = [client performSearch:@"franck&tanoh" withScope:UsersSearchScope withRepresentation:JSONFormat];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"blast" withScope:ServicesSearchScope withRepresentation:JSONFormat];
  STAssertNotNil(results, @"nil JSON document returned for 'blast'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
  
  results = [client performSearch:@"blast*" withScope:ServicesSearchScope withRepresentation:JSONFormat];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
  results = [client performSearch:@"ebi" withScope:ProvidersSearchScope withRepresentation:JSONFormat];
  STAssertNotNil(results, @"nil JSON document returned for 'ebi'");
  STAssertTrue([[results objectForKey:JSONResultsElement] count] > 0, @"Incorrect results count yeiled.");
  
  results = [client performSearch:@"e-b+i" withScope:ProvidersSearchScope withRepresentation:JSONFormat];
  STAssertNil(results, [NSString stringWithFormat:@"Found %@", results]);
  
}

-(void) tearDown {
  [client release];
}

@end
