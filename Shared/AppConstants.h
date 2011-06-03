//
//  AppConstants.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//


#pragma mark -
#pragma mark Notifications

extern NSString *const NetworkActivityStarted;
extern NSString *const NetworkActivityStopped;

extern NSString *const ErrorOccurred;

extern NSTimeInterval const UpdateCheckInterval;


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

extern NSString *const RESTEndpointResourceScope;
extern NSString *const SOAPOperationResourceScope;

extern NSString *const AnnouncementResourceScope;

extern NSString *const InternetConnectionTestResourceScope;

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

extern NSString *const JSONDateFormat;

extern NSString *const JSONAffiliationElement;
extern NSString *const JSONArchivedAtElement;
extern NSString *const JSONCityElement;
extern NSString *const JSONContentTypeElement;
extern NSString *const JSONCountryCodeElement;
extern NSString *const JSONCountryElement;
extern NSString *const JSONCreatedAtElement;
extern NSString *const JSONDeploymentsElement;
extern NSString *const JSONDescriptionElement;
extern NSString *const JSONEndpointLabelElement;
extern NSString *const JSONErrorsElement;
extern NSString *const JSONFlagElement;
extern NSString *const JSONInputsElement;
extern NSString *const JSONJoinedElement;
extern NSString *const JSONLabelElement;
extern NSString *const JSONLastCheckedElement;
extern NSString *const JSONLatestMonitoringStatusElement;
extern NSString *const JSONLocationElement;
extern NSString *const JSONMethodsElement;
extern NSString *const JSONNameElement;
extern NSString *const JSONOperationsElement;
extern NSString *const JSONOutputsElement;
extern NSString *const JSONPagesElement;
extern NSString *const JSONParametersElement;
extern NSString *const JSONProviderElement;
extern NSString *const JSONPublicEmailElement;
extern NSString *const JSONRepresentationElement;
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
extern NSString *const JSONTestScriptElement;
extern NSString *const JSONTestTypeElement;
extern NSString *const JSONTotalElement;
extern NSString *const JSONURLElement;
extern NSString *const JSONURLMonitorElement;
extern NSString *const JSONUserElement;
extern NSString *const JSONVariantsElement;

extern NSString *const JSONIDElement;


#pragma mark -
#pragma mark Image Names

extern NSString *const CustomCellXIB;

extern NSString *const BrushedMetalBackground;

extern NSString *const TableCellBackground;
extern NSString *const TableCellSelectedBackground;

extern NSString *const GreenLineImage;
extern NSString *const RedLineImage;
extern NSString *const GreyLineImage;

extern NSString *const ProviderIcon;
extern NSString *const UserIcon;

extern NSString *const AnnouncementReadIcon;
extern NSString *const AnnouncementUnreadIcon;

extern NSString *const ServiceUnstarredIcon;
extern NSString *const ServiceStarredIcon;

extern NSString *const CogIcon;
extern NSString *const DotIcon;


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

extern NSString *NoAlternativeNameText;


#pragma mark -
#pragma mark Error Codes

extern NSString *const BioCatalogueClientErrorDomain;

typedef enum {
  LoginError = 101,
  InvalidEmailAddressError,
  InvalidPasswordError
} BioCatalogueErrorCode;

typedef enum {
  NoInternetConnectionError = -1009,
  ConnectionToServerError = -1004
} NSErrorCode;

/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@interface AppConstants : NSObject {

}

@end
