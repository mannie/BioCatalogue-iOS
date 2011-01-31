//
//  TestBioCatalogueClient.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 1

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>

#import "BioCatalogueClient.h"


@interface TestBioCatalogueClient : SenTestCase {
  NSString *message;
}

-(void) testBaseURL;
-(void) testURLForPathWithRepresentation;
-(void) testPerformSearchWithScopeAndRepresentationPage;

-(void) testGETdocumentAtPath;
-(void) testGETLatestServices;
-(void) testGETServicesAtPage;

@end
