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
  
  GestureHandler *gestureHandler;
  
  NSDictionary *listingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *userProperties;
  NSDictionary *providerProperties;
  
  BOOL viewHasAlreadyInitialized;

  IBOutlet UITableView *containerTableView;
  
  // the default view
  IBOutlet UIView *defaultView;
  IBOutlet UIToolbar *defaultViewToolbar;
  IBOutlet UIActivityIndicatorView *defaultViewActivityIndicator;

  IBOutlet UILabel *loadingTextLabel;
  NSString *loadingText;
  
  // the service view
  BOOL descriptionAvailable;
  BOOL monitoringStatusInformationAvailable;

  IBOutlet UIView *serviceDetailView;
  IBOutlet UIToolbar *serviceViewToolbar;
  IBOutlet UIActivityIndicatorView *serviceViewActivityIndicator;
  
  IBOutlet UILabel *serviceNameLabel;
  IBOutlet UITextView *serviceDescriptionLabel;
  IBOutlet UILabel *serviceProviderNameLabel;
  IBOutlet UILabel *serviceSubmitterNameLabel;
  
  // the user view
  IBOutlet UIView *userDetailView;
  IBOutlet UIToolbar *userViewToolbar;
  IBOutlet UIActivityIndicatorView *userViewActivityIndicator;

  IBOutlet UIView *userDetailIDCardView;
  
  IBOutlet UILabel *userNameLabel;
  IBOutlet UILabel *userAffiliationLabel;
  IBOutlet UILabel *userCountryLabel;
  IBOutlet UILabel *userCityLabel;
  IBOutlet UILabel *userEmailLabel;
  IBOutlet UILabel *userJoinedLabel;

  // the provider view
  IBOutlet UIView *providerDetailView;
  IBOutlet UIToolbar *providerViewToolbar;
  IBOutlet UIActivityIndicatorView *providerViewActivityIndicator;  
}

@property (nonatomic, retain) NSString *loadingText;

-(void) setServiceDescription:(NSString *)description;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startAnimatingActivityIndicators;
-(void) stopAnimatingActivityIndicators;

@end
