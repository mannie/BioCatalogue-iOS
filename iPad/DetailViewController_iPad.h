//
//  DetailViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GestureHandler_iPad.h"

#import "UIView+Helper.h"
#import "NSUserDefaults+Helper.h"

#import "MonitoringStatusViewController.h"
#import "ServiceComponentsViewController.h"


@interface DetailViewController_iPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
  UIPopoverController *defaultPopoverController;
  UIPopoverController *contextualPopoverController;
  
  IBOutlet GestureHandler_iPad *gestureHandler;
  
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

  // the default view
  IBOutlet UIView *defaultView;
  
  // the service view
  BOOL monitoringStatusInformationAvailable;

  IBOutlet UIView *serviceDetailView;
  
  IBOutlet UILabel *serviceNameLabel;
  IBOutlet UITextView *serviceDescriptionLabel;
  IBOutlet UILabel *serviceProviderNameLabel;
  IBOutlet UILabel *serviceSubmitterNameLabel;
  
  IBOutlet UILabel *componentsLabel;
  IBOutlet UIButton *showComponentsButton;
  ServiceComponentsViewController *serviceComponentsViewController;
  
  MonitoringStatusViewController *monitoringStatusViewController;
  IBOutlet UIImageView *monitoringStatusIcon;

  // the user view
  IBOutlet UIView *userDetailView;
  IBOutlet UIView *userIDCard;
  IBOutlet UIView *userIDCardContainer;
  
  IBOutlet UILabel *userNameLabel;
  IBOutlet UILabel *userAffiliationLabel;
  IBOutlet UILabel *userCountryLabel;
  IBOutlet UILabel *userCityLabel;
  IBOutlet UILabel *userEmailLabel;
  IBOutlet UILabel *userJoinedLabel;

  // the provider view
  IBOutlet UIView *providerDetailView;
  IBOutlet UIView *providerIDCard;
  IBOutlet UIView *providerIDCardContainer;

  IBOutlet UILabel *providerNameLabel;
  IBOutlet UITextView *providerDescriptionLabel;
}

@property (nonatomic, retain) IBOutlet MonitoringStatusViewController *monitoringStatusViewController;
@property (nonatomic, retain) IBOutlet ServiceComponentsViewController *serviceComponentsViewController;

-(BOOL) isCurrentlyBusy;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startLoadingAnimation;
-(void) stopLoadingAnimation;

-(IBAction) showProviderInfo:(id)sender;
-(IBAction) showSubmitterInfo:(id)sender;
-(IBAction) showMonitoringStatusInfo:(id)sender;
-(IBAction) showServiceComponents:(id)sender;

-(IBAction) dismissAuxiliaryDetailPanel:(id)sender;
-(IBAction) exposeAuxiliaryDetailPanel:(id)sender;

-(IBAction) showCurrentResourceInBioCatalogue:(id)sender;
-(IBAction) showResourceInBioCatalogue:(NSURL *)url;

@end
