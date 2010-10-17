//
//  AppConstants.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppConstants.h"


NSInteger const ServiceNameTag = 1;
NSInteger const ServiceDescriptionTag = 2;

NSUInteger const LatestServices = 10;
NSUInteger const ServicesPerPage = 10;

NSString *const BioCatalogueHostname = @"sandbox.biocatalogue.org";

NSString *const JSONFormat = @"json";
NSString *const XMLFormat = @"xml";

NSString *const JSONNull = @"<null>";

NSString *const JSONResultsElement = @"results";
NSString *const JSONNameElement = @"name";
NSString *const JSONDescriptionElement = @"description";
NSString *const JSONResourceElement = @"resource";
NSString *const JSONSubmitterElement = @"submitter";
NSString *const JSONLatestMonitoringStatusElement = @"latest_monitoring_status";
NSString *const JSONStatusElement = @"status";
NSString *const JSONLabelElement = @"label";
NSString *const JSONTechnologyTypesElement = @"service_technology_types";
NSString *const JSONDeploymentsElement = @"deployments";
NSString *const JSONProviderElement = @"provider";
NSString *const JSONLocationElement = @"location";
NSString *const JSONCityElement = @"city";
NSString *const JSONCountryElement = @"country";
NSString *const JSONCountryCodeElement = @"country_code";
NSString *const JSONFlagElement = @"flag";
NSString *const JSONLastCheckedElement = @"last_checked";
NSString *const JSONServiceTestsElement = @"service_tests";
NSString *const JSONServiceTestElement = @"service_test";
NSString *const JSONSmallSymbolElement = @"small_symbol";
NSString *const JSONSymbolElement = @"symbol";

NSString *const UsersSearchScope = @"users";
NSString *const ServicesSearchScope = @"services";
NSString *const ProvidersSearchScope = @"providers";

NSString *const RESTService = @"REST";
NSString *const SOAPService = @"SOAP";


/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@implementation AppConstants

@end
