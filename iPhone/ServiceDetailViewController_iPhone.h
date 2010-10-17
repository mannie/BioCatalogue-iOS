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


@interface ServiceDetailViewController_iPhone : UITableViewController {
  UILabel *name;

  NSDictionary *serviceListingProperties;
  NSDictionary *serviceProperties;
  NSDictionary *serviceMonitoringProperties;
  NSDictionary *submitterProperties;
  
  UserDetailViewController_iPhone *userDetailViewController;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UserDetailViewController_iPhone *userDetailViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

@end
