//
//  DetailViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureHandler.h"


@interface DetailViewController_iPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
  UIPopoverController *defaultPopoverController;
  UIPopoverController *contextualPopoverController;
  
  IBOutlet GestureHandler *gestureHandler;
  
  NSDictionary *listingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *userProperties;
  NSDictionary *providerProperties;
  
  NSString *scopeOfResourceBeingViewed;
  
  BOOL viewHasAlreadyInitialized;

  IBOutlet UITableView *containerTableView;

  IBOutlet UIToolbar *toolbar;
  IBOutlet UIBarButtonItem *favouriteServiceBarButtonItem;
  IBOutlet UIBarButtonItem *viewResourceInBioCatalogueBarButtonItem;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;

  // the default view
  IBOutlet UIView *defaultView;

  IBOutlet UILabel *loadingTextLabel;
  NSString *loadingText;
  
  // the service view
  BOOL monitoringStatusInformationAvailable;

  IBOutlet UIView *serviceDetailView;
  
  IBOutlet UILabel *serviceNameLabel;
  IBOutlet UITextView *serviceDescriptionLabel;
  IBOutlet UILabel *serviceProviderNameLabel;
  IBOutlet UILabel *serviceSubmitterNameLabel;
  
  // the user view
  IBOutlet UIView *userDetailView;
  IBOutlet UIView *userDetailIDCardView;
  
  IBOutlet UILabel *userNameLabel;
  IBOutlet UILabel *userAffiliationLabel;
  IBOutlet UILabel *userCountryLabel;
  IBOutlet UILabel *userCityLabel;
  IBOutlet UILabel *userEmailLabel;
  IBOutlet UILabel *userJoinedLabel;

  // the provider view
  IBOutlet UIView *providerDetailView;
  IBOutlet UIView *providerDetailIDCardView;
  
  IBOutlet UILabel *providerNameLabel;
  IBOutlet UITextView *providerDescriptionLabel;
}

@property (nonatomic, retain) NSString *loadingText;

-(void) setDescription:(NSString *)description;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startAnimatingActivityIndicators;
-(void) stopAnimatingActivityIndicators;

-(IBAction) viewSubmitterInformation:(id)sender;

@end
