//
//  AppConstants.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark Notifications

extern NSString *const NetworkActivityStarted;
extern NSString *const NetworkActivityStopped;


#pragma mark -
#pragma mark BioCatalogueClient

extern NSString *const AppServiceName;

extern NSUInteger const DaysBeforeExpiringUnreadAnnouncements;

extern NSUInteger const iPadItemsPerPage;
extern NSUInteger const iPhoneItemsPerPage;
extern NSUInteger ItemsPerPage;

extern NSUInteger AutoLoadTrigger;
extern float AutoLoadTriggerIndex;

extern NSTimeInterval const APIRequestTimeout;

extern NSString *const UserResourceScope;
extern NSString *const ServiceResourceScope;
extern NSString *const ProviderResourceScope;

extern NSString *const AnnouncementResourceScope;

extern NSString *const RESTService;
extern NSString *const SOAPService;

extern NSString *const BioCatalogueHostname;


#pragma mark -
#pragma mark BioCatalogue Search Indexes

extern NSUInteger const ServiceResourceScopeIndex;
extern NSUInteger const UserResourceScopeIndex;
extern NSUInteger const ProviderResourceScopeIndex;


#pragma mark -
#pragma mark JSON Elements

extern NSString *const JSONFormat;
extern NSString *const XMLFormat;

extern NSString *const JSONNull;

extern NSString *const JSONAffiliationElement;
extern NSString *const JSONArchivedAtElement;
extern NSString *const JSONCityElement;
extern NSString *const JSONCountryCodeElement;
extern NSString *const JSONCountryElement;
extern NSString *const JSONDeploymentsElement;
extern NSString *const JSONDescriptionElement;
extern NSString *const JSONEndpointLabelElement;
extern NSString *const JSONErrorsElement;
extern NSString *const JSONFlagElement;
extern NSString *const JSONJoinedElement;
extern NSString *const JSONLabelElement;
extern NSString *const JSONLastCheckedElement;
extern NSString *const JSONLatestMonitoringStatusElement;
extern NSString *const JSONLocationElement;
extern NSString *const JSONMethodsElement;
extern NSString *const JSONNameElement;
extern NSString *const JSONOperationsElement;
extern NSString *const JSONPagesElement;
extern NSString *const JSONProviderElement;
extern NSString *const JSONPublicEmailElement;
extern NSString *const JSONResourceElement;
extern NSString *const JSONResultsElement;
extern NSString *const JSONSearchQueryElement;
extern NSString *const JSONSelfElement;
extern NSString *const JSONServiceTestsElement;
extern NSString *const JSONSmallSymbolElement;
extern NSString *const JSONStatusElement;
extern NSString *const JSONSubmitterElement;
extern NSString *const JSONSymbolElement;
extern NSString *const JSONTechnologyTypesElement;
extern NSString *const JSONTestTypeElement;
extern NSString *const JSONTotalElement;
extern NSString *const JSONURLElement;
extern NSString *const JSONURLMonitorElement;
extern NSString *const JSONUserElement;
extern NSString *const JSONVariantsElement;


#pragma mark -
#pragma mark Image Names

extern NSString *const BrushedMetalBackground;

extern NSString *const TableCellBackground;
extern NSString *const TableCellSelectedBackground;

extern NSString *const DescriptionIcon;
extern NSString *const ProviderIcon;
extern NSString *const UserIcon;

extern NSString *const AnnouncementReadIcon;
extern NSString *const AnnouncementUnreadIcon;


#pragma mark -
#pragma mark NSUserDefaults

extern NSString *const LastViewedResourceKey;
extern NSString *const LastViewedResourceScopeKey;
extern NSString *const LastLoggedInUserKey;

#pragma mark -
#pragma mark Text Placeholders

extern NSString *UnknownText;
extern NSString *UnknownAffiliationText;
extern NSString *DefaultLoadingText;
extern NSString *LoadMoreItemsText;

extern NSString *NoDescriptionText;
extern NSString *NoInformationText;

extern NSString *RESTComponentsText;
extern NSString *SOAPComponentsText;



/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@interface AppConstants : NSObject {

}

@end
