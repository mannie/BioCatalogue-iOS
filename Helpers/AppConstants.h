//
//  AppConstants.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSInteger const ServiceNameTag;
extern NSInteger const ServiceDescriptionTag;

extern NSUInteger const LatestServices;
extern NSUInteger const ServicesPerPage;

extern NSString *const BioCatalogueHostname;

extern NSString *const JSONFormat;
extern NSString *const XMLFormat;

extern NSString *const JSONNull;

extern NSString *const JSONResultsElement;
extern NSString *const JSONNameElement;
extern NSString *const JSONDescriptionElement;
extern NSString *const JSONResourceElement;
extern NSString *const JSONSubmitterElement;
extern NSString *const JSONLatestMonitoringStatusElement;
extern NSString *const JSONStatusElement;
extern NSString *const JSONLabelElement;
extern NSString *const JSONTechnologyTypesElement;
extern NSString *const JSONDeploymentsElement;
extern NSString *const JSONProviderElement;
extern NSString *const JSONLocationElement;
extern NSString *const JSONCityElement;
extern NSString *const JSONCountryElement;
extern NSString *const JSONCountryCodeElement;
extern NSString *const JSONFlagElement;
extern NSString *const JSONLastCheckedElement;
extern NSString *const JSONServiceTestsElement;
extern NSString *const JSONServiceTestElement;
extern NSString *const JSONSmallSymbolElement;
extern NSString *const JSONSymbolElement;

extern NSString *const UsersSearchScope;
extern NSString *const ServicesSearchScope;
extern NSString *const ProvidersSearchScope;

extern NSString *const RESTService;
extern NSString *const SOAPService;


/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@interface AppConstants : NSObject {

}

@end
