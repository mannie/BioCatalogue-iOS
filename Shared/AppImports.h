/*
 *  AppImports.h
 *  BioMonitor
 *
 *  Created by Mannie Tagarira on 26/02/2011.
 *  Copyright 2011 University of Manchester. All rights reserved.
 *
 */


#pragma mark -
#pragma mark Frameworks

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MessageUI/MessageUI.h>

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark 3rd Party Frameworks

#import "MWFeedParser.h"
#import "JSONKit.h"

#import "SFHFKeychainUtils.h"

#import "TVOutManager.h"

#import "TPKeyboardAvoidingTableView.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "SVWebViewController.h"

#import "FlatWebView.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark 3rd Party Categories

#import "NSString+HTML.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark Core Data Models

#import "Announcement.h"
#import "BioCatalogue.h"
#import "Service.h"
#import "User.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark Categories

#import "NSString+Helper.h"
#import "NSUserDefaults+Helper.h"
#import "UIDevice+Helper.h"
#import "NSDictionary+Helper.h"
#import "NSError+Helper.h"
#import "NSException+Helper.h"
#import "NSObject+Helper.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark Shared Code

#import "AppConstants.h"

#import "AppDelegate_Shared.h"

#import "BioCatalogueClient.h"
#import "BioCatalogueResourceManager.h"

#import "UpdateCenter.h"

// controllers
#import "UIContentController.h"
#import "WebBrowserController.h"

// detail view controllers
#import "MonitoringStatusViewController.h"
#import "ServiceComponentsViewController.h"
#import "ServiceComponentsDetailViewController.h"
#import "ProviderDetailViewController.h"
#import "ProviderServicesViewController.h"

// root tab bar view controllers
#import "PullToRefreshViewController.h"
#import "BrowseByProviderViewController.h"
#import "BrowseByDateViewController.h"
#import "SearchViewController.h"
#import "AnnouncementsViewController.h"
#import "MyStuffViewController.h"
#import "LoginViewController.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark iPhone Specific Code

#import "AppDelegate_iPhone.h"

#import "AnnouncementDetailViewController_iPhone.h"
#import "ServiceDetailViewController_iPhone.h"
#import "UserDetailViewController_iPhone.h"

// * *** *** *** ** *** *** *** ** *** *** *** * 

#pragma mark -
#pragma mark iPad Specific Code

#import "AppDelegate_iPad.h"

#import "DetailViewController_iPad.h"
#import "GestureHandler_iPad.h"

