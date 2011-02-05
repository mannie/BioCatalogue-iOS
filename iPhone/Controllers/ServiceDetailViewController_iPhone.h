//
//  ServiceDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BioCatalogueClient.h"

#import "UserDetailViewController_iPhone.h"
#import "ProviderDetailViewController.h"
#import "MonitoringStatusViewController.h"
#import "ServiceComponentsViewController.h"
#import "UIContentController.h"

#import "NSDictionary+Helper.h"


@interface ServiceDetailViewController_iPhone : UIViewController {
  IBOutlet UITableView *myTableView;
  IBOutlet UIContentController *uiContentController;
  IBOutlet UIButton *providerButton;
  
  NSDictionary *serviceListingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *submitterProperties;
  
  UserDetailViewController_iPhone *userDetailViewController;
  ProviderDetailViewController *providerDetailViewController;
  MonitoringStatusViewController *monitoringStatusViewController;
  ServiceComponentsViewController *serviceComponentsViewController;
  
  BOOL monitoringStatusInformationAvailable;
  BOOL descriptionAvailable;
}

@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController *providerDetailViewController;
@property (nonatomic, retain) IBOutlet MonitoringStatusViewController *monitoringStatusViewController;
@property (nonatomic, retain) IBOutlet ServiceComponentsViewController *serviceComponentsViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

-(IBAction) showProviderInfo:(id)sender;
-(IBAction) showSubmitterInfo:(id)sender;
-(IBAction) showMonitoringStatusInfo:(id)sender;
-(IBAction) showServiceComponents:(id)sender;

-(void) makeShowProvidersButtonVisible:(BOOL)visible;

@end
