//
//  ServiceDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"

#import "UserDetailViewController_iPhone.h"
#import "ProviderDetailViewController_iPhone.h"
#import "MonitoringStatusTableViewController_iPhone.h"
#import "DescriptionViewController_iPhone.h"


@interface ServiceDetailViewController_iPhone : UITableViewController {
  IBOutlet UILabel *name;
  
  NSDictionary *serviceListingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *submitterProperties;
  
  UserDetailViewController_iPhone *userDetailViewController;
  ProviderDetailViewController_iPhone *providerDetailViewController;
  MonitoringStatusTableViewController_iPhone *monitoringStatusViewController;
  DescriptionViewController_iPhone *descriptionViewController;
  
  BOOL monitoringStatusInformationAvailable;
  BOOL descriptionAvailable;
}

@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;
@property (nonatomic, retain) IBOutlet ProviderDetailViewController_iPhone *providerDetailViewController;
@property (nonatomic, retain) IBOutlet MonitoringStatusTableViewController_iPhone *monitoringStatusViewController;
@property (nonatomic, retain) IBOutlet DescriptionViewController_iPhone *descriptionViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

@end
