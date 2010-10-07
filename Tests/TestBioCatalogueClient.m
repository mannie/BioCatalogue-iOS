//
//  TestBioCatalogueClient.m
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

-(void) testPerformSearchWithRepresentation {
  NSDictionary *search = [BioCatalogueClient performSearch:@"" withRepresentation:nil];
  STAssertNil(search, [NSString stringWithFormat:@"Found %@", search]);

  search = [BioCatalogueClient performSearch:@"blast" withRepresentation:nil];
  STAssertNil(search, [NSString stringWithFormat:@"Found %@", search]);

  search = [BioCatalogueClient performSearch:@"search?q=blast" withRepresentation:JSONFormat];
  STAssertNil(search, [NSString stringWithFormat:@"Found %@", search]);

  search = [BioCatalogueClient performSearch:@"blast&scope=services" withRepresentation:JSONFormat];
  STAssertNil(search, [NSString stringWithFormat:@"Found %@", search]);

  search = [BioCatalogueClient performSearch:@"blast" withRepresentation:JSONFormat];
  STAssertNotNil(search, @"nil JSON document returned for 'blast'");
  STAssertTrue([[search objectForKey:ResultsKey] count] > 3, @"Incorrect results count yeiled.");

  search = [BioCatalogueClient performSearch:@"blast" withRepresentation:XMLFormat];
  STAssertNotNil(search, @"nil XML document returned for 'blast'");
  STAssertTrue([[search objectForKey:ResultsKey] count] > 3, @"Incorrect results count yeiled.");
}

@end
