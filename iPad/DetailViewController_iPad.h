//
//  DetailViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailViewController_iPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
  UIPopoverController *popoverController;
  NSString *loadingText;

  IBOutlet UIToolbar *defaultToolbar;
  IBOutlet UIToolbar *serviceDetailToolbar;
  UIToolbar *currentToolbar;
  
  IBOutlet UILabel *loadingTextLabel;
  
  IBOutlet UIView *defaultView;
  IBOutlet UIView *serviceDetailView;
  
  NSDictionary *listingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *userProperties;
  NSDictionary *providerProperties;
  
  BOOL monitoringStatusInformationAvailable;
  BOOL descriptionAvailable;
  
  IBOutlet UILabel *nameLabel;
  IBOutlet UITextView *descriptionLabel;
  IBOutlet UILabel *providerNameLabel;
  IBOutlet UITextView *providerDescriptionLabel;
  IBOutlet UILabel *submitterNameLabel;
  IBOutlet UITextView *submitterInfoLabel;
  IBOutlet UIImageView *countryFlagIcon;
  
  IBOutlet UIActivityIndicatorView *defaultActivityIndicator;
  IBOutlet UIActivityIndicatorView *serviceDetailActivityIndicator;
}

@property (nonatomic, retain) NSString *loadingText;

@property (nonatomic, retain) UIPopoverController *popoverController;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startAnimatingActivityIndicators;
-(void) stopAnimatingActivityIndicators;

@end
