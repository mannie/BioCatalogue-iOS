//
//  AppConstants.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark BioCatalogueClient

extern NSUInteger const LatestServices;
extern NSUInteger const ServicesPerPage;

extern NSString *const UsersSearchScope;
extern NSString *const ServicesSearchScope;
extern NSString *const ProvidersSearchScope;

extern NSString *const RESTService;
extern NSString *const SOAPService;

extern NSString *const BioCatalogueHostname;


#pragma mark -
#pragma mark JSON Elements

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
extern NSString *const JSONSmallSymbolElement;
extern NSString *const JSONSymbolElement;


#pragma mark -
#pragma mark Icon Names

extern NSString *const DescriptionIcon;

extern NSString *const ProviderIcon;
extern NSString *const UserIcon;



/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@interface AppConstants : NSObject {

}

@end
