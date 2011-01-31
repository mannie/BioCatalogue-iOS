//
//  DetailViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GestureHandler_iPad.h"

#import "NSUserDefaults+Helper.h"
#import "NSDictionary+Helper.h"

#import "MonitoringStatusViewController.h"
#import "ServiceComponentsViewController.h"
#import "WebBrowserController.h"

#import "UIContentController.h"

#import "BioCatalogueResourceManager.h"


@interface DetailViewController_iPad : UIViewController <UIWebViewDelegate, UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
  UIPopoverController *defaultPopoverController;
  UIPopoverController *contextualPopoverController;
  
  IBOutlet GestureHandler_iPad *gestureHandler;
  IBOutlet UIContentController *uiContentController;
  
  NSDictionary *listingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *userProperties;
  NSDictionary *providerProperties;
  
  NSString *scopeOfResourceBeingViewed;
  
  BOOL viewHasAlreadyInitialized;
  BOOL controllerIsCurrentlyBusy;

  IBOutlet UIView *mainContentView;
  IBOutlet UIView *auxiliaryDetailPanel;
  IBOutlet UIView *interactionDisablingLayer;
  
  IBOutlet UIToolbar *mainToolbar;
  IBOutlet UIToolbar *auxiliaryToolbar;
  IBOutlet UIToolbar *webBrowserToolbar;

  IBOutlet UIWebView *webBrowser;

  IBOutlet UIBarButtonItem *favouriteServiceBarButtonItem;
  IBOutlet UIBarButtonItem *viewResourceInBioCatalogueBarButtonItem;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
  IBOutlet UIActivityIndicatorView *webBrowserActivityIndicator;

  UIView *currentMainContentView;
  UIView *currentAuxiliaryPanelView;
  
  // the default view
  IBOutlet UIView *defaultView;
  
  // the service view
  BOOL monitoringStatusInformationAvailable;
  IBOutlet UILabel *serviceName;
  IBOutlet UIView *serviceDetailView;
  
  ServiceComponentsViewController *serviceComponentsViewController;  
  MonitoringStatusViewController *monitoringStatusViewController;

  // the user view
  IBOutlet UIView *userDetailView;
  IBOutlet UIView *userIDCard;
  IBOutlet UIView *userIDCardContainer;
  
  // the provider view
  IBOutlet UIView *providerDetailView;
  IBOutlet UIView *providerIDCard;
  IBOutlet UIView *providerIDCardContainer;
}

@property (nonatomic, retain) IBOutlet MonitoringStatusViewController *monitoringStatusViewController;
@property (nonatomic, retain) IBOutlet ServiceComponentsViewController *serviceComponentsViewController;
@property (nonatomic, retain) IBOutlet WebBrowserController *webBrowserController;

-(BOOL) isCurrentlyBusy;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startLoadingAnimation;
-(void) stopLoadingAnimation;

-(IBAction) markUnmarkServiceAsFavourite:(id)sender;

-(IBAction) showProviderInfo:(id)sender;
-(IBAction) showSubmitterInfo:(id)sender;
-(IBAction) showMonitoringStatusInfo:(id)sender;
-(IBAction) showServiceComponents:(id)sender;

-(IBAction) dismissAuxiliaryDetailPanel:(id)sender;
-(IBAction) exposeAuxiliaryDetailPanel:(id)sender;

-(IBAction) showCurrentResourceInBioCatalogue:(id)sender;
-(IBAction) showResourceInBioCatalogue:(NSURL *)url;

@end
