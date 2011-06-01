//
//  AppConstants.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


#pragma mark -
#pragma mark Notifications

NSString *const NetworkActivityStarted = @"NetworkActivityStartedNotification";
NSString *const NetworkActivityStopped = @"NetworkActivityStoppedNotification";

NSString *const ErrorOccurred = @"ErrorOccurredNotification";

NSTimeInterval const UpdateCheckInterval = 5; // in seconds TODO: 15 * 60


#pragma mark -
#pragma mark BioCatalogueClient

NSString *const AppServiceName = @"BioCatalogue (iOS)";

NSUInteger const DaysBeforeExpiringUnreadAnnouncements = 90;

NSUInteger const iPadItemsPerPage = 10;
NSUInteger const iPhoneItemsPerPage = 10;
NSUInteger ItemsPerPage = -1; // NOTE: ItemsPerPage will be replaced at runtime

NSUInteger AutoLoadTrigger = -1; // NOTE: AutoLoadTrigger will be replaced at runtime using AutoLoadTriggerIndex * ItemsPerPage 
float AutoLoadTriggerIndex = 0.8;

NSTimeInterval const APIRequestTimeout = 10;

NSString *const UserResourceScope = @"users";
NSString *const ServiceResourceScope = @"services";
NSString *const ProviderResourceScope = @"providers";

NSString *const AnnouncementResourceScope = @"announcements";

NSString *const RESTService = @"REST";
NSString *const SOAPService = @"SOAP";

NSString *const BioCatalogueHostname = @"sandbox.biocatalogue.org";
//NSString *const BioCatalogueHostname = @"test.biocatalogue.org";
//NSString *const BioCatalogueHostname = @"www.biocatalogue.org";
//NSString *const BioCatalogueHostname = @"demo.edunify.pesc.org";


#pragma mark -
#pragma mark BioCatalogue Search Indexes

NSUInteger const ServiceResourceScopeIndex = 0;
NSUInteger const UserResourceScopeIndex = 1;
NSUInteger const ProviderResourceScopeIndex = 2;


#pragma mark -
#pragma mark JSON Elements

NSString *const JSONFormat = @"json";
NSString *const XMLFormat = @"xml";

NSString *const JSONNull = @"<null>";

NSString *const JSONDateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";

NSString *const JSONAffiliationElement = @"affiliation";
NSString *const JSONArchivedAtElement = @"archived_at";
NSString *const JSONCityElement = @"city";
NSString *const JSONContentTypeElement = @"content_type";
NSString *const JSONCountryCodeElement = @"country_code";
NSString *const JSONCountryElement = @"country";
NSString *const JSONCreatedAtElement = @"created_at";
NSString *const JSONDeploymentsElement = @"deployments";
NSString *const JSONDescriptionElement = @"description";
NSString *const JSONEndpointLabelElement = @"endpoint_label";
NSString *const JSONErrorsElement = @"errors";
NSString *const JSONFlagElement = @"flag";
NSString *const JSONInputsElement = @"inputs";
NSString *const JSONJoinedElement = @"joined";
NSString *const JSONLabelElement = @"label";
NSString *const JSONLastCheckedElement = @"last_checked";
NSString *const JSONLatestMonitoringStatusElement = @"latest_monitoring_status";
NSString *const JSONLocationElement = @"location";
NSString *const JSONMethodsElement = @"methods";
NSString *const JSONNameElement = @"name";
NSString *const JSONOperationsElement = @"operations";
NSString *const JSONOutputsElement = @"outputs";
NSString *const JSONPagesElement = @"pages";
NSString *const JSONParametersElement = @"parameters";
NSString *const JSONProviderElement = @"provider";
NSString *const JSONPublicEmailElement = @"public_email";
NSString *const JSONRepresentationElement = @"representations";
NSString *const JSONResourceElement = @"resource";
NSString *const JSONResultsElement = @"results";
NSString *const JSONSearchQueryElement = @"search_query";
NSString *const JSONSelfElement = @"self";
NSString *const JSONServiceTestsElement = @"service_tests";
NSString *const JSONSmallSymbolElement = @"small_symbol";
NSString *const JSONStatusElement = @"status";
NSString *const JSONSubmitterElement = @"submitter";
NSString *const JSONSymbolElement = @"symbol";
NSString *const JSONTechnologyTypesElement = @"service_technology_types";
NSString *const JSONTestScriptElement = @"test_script";
NSString *const JSONTestTypeElement = @"test_type";
NSString *const JSONTotalElement = @"total";
NSString *const JSONURLElement = @"url";
NSString *const JSONURLMonitorElement = @"url_monitor";
NSString *const JSONUserElement = @"user";
NSString *const JSONVariantsElement = @"variants";


#pragma mark -
#pragma mark Image Names

NSString *const CustomCellXIB = @"CustomCell";

NSString *const BrushedMetalBackground = @"brushed-metal.jpg";

NSString *const TableCellBackground = @"cellRow.png";
NSString *const TableCellSelectedBackground = @"cellRowSelected.png";

NSString *const GreenLineImage = @"greenLine.png";
NSString *const RedLineImage = @"redLine.png";
NSString *const GreyLineImage = @"greyLine.png";

//NSString *const ProviderIcon = @"112-group.png";
//NSString *const UserIcon = @"111-user.png";
NSString *const ProviderIcon = @"people-family4.png";
NSString *const UserIcon = @"people-head.png";

NSString *const AnnouncementReadIcon = @"check-mark.png";
NSString *const AnnouncementUnreadIcon = @"exclamation-point-ps.png";

NSString *const ServiceUnstarredIcon = @"star4.png";
NSString *const ServiceStarredIcon = @"star8-sc48.png";

NSString *const CogIcon = @"cog.png";
NSString *const DotIcon = @"circle-solid.png";


#pragma mark -
#pragma mark NSUserDefaults

NSString *const LastViewedResourceKey = @"LastViewedResource";
NSString *const LastViewedResourceScopeKey = @"LastViewedResourceScope";
NSString *const LastLoggedInUserKey = @"LastLoggedInUser";


#pragma mark -
#pragma mark Text Placeholders

NSString *UnknownText = @"Unknown";
NSString *UnknownAffiliationText = @"Unknown Affiliation";
NSString *DefaultLoadingText = @"Loading, Please Wait...";
NSString *LoadMoreItemsText = @"Load More Items...";

NSString *NoDescriptionText = @"(no description available)";
NSString *NoInformationText = @"(no additional information available)";

NSString *RESTComponentsText = @"REST Endpoints";
NSString *SOAPComponentsText = @"SOAP Operations";

NSString *NoAlternativeNameText = @"(no alternative name)";


#pragma mark -
#pragma mark Error Codes

NSString *const BioCatalogueClientErrorDomain = @"BioCatalogueClientErrorDomain";


/* * *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** ** *** *** *** * */


@implementation AppConstants

@end
