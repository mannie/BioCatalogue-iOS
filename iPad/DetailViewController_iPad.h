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
  UIPopoverController *popoverController;
  NSString *loadingText;

  IBOutlet UIToolbar *defaultToolbar;
  IBOutlet UIToolbar *serviceDetailToolbar;
  
  IBOutlet UILabel *loadingTextLabel;
  
  IBOutlet UIView *defaultView;
  IBOutlet UIView *serviceDetailView;
  
  NSDictionary *listingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *userProperties;
  NSDictionary *providerProperties;
  
  BOOL monitoringStatusInformationAvailable;
  BOOL descriptionAvailable;
  BOOL viewHasAlreadyInitialized;
  
  IBOutlet UILabel *nameLabel;
  IBOutlet UITextView *descriptionLabel;
  IBOutlet UILabel *providerNameLabel;
  IBOutlet UILabel *submitterNameLabel;
  
  IBOutlet UIActivityIndicatorView *defaultActivityIndicator;
  IBOutlet UIActivityIndicatorView *serviceDetailActivityIndicator;
  
  IBOutlet UITableView *componentsTableView;
  
  GestureHandler *gestureHandler;
}

@property (nonatomic, retain) NSString *loadingText;

@property (nonatomic, retain) UIPopoverController *popoverController;

-(void) setServiceDescription:(NSString *)description;

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties;
-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties;

-(void) startAnimatingActivityIndicators;
-(void) stopAnimatingActivityIndicators;

@end
