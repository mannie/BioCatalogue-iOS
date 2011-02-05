//
//  ProviderDetailViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConstants.h"
#import "NSString+Helper.h"

#import "ProviderServicesViewController.h"


@interface ProviderDetailViewController : UIViewController {
  IBOutlet UILabel *name;
  IBOutlet UITextView *descriptionTextView;

  IBOutlet UIBarButtonItem *servicesButton;

  NSDictionary *providerProperties;
  
  ProviderServicesViewController *providerServicesViewController;
}

@property(nonatomic, retain) IBOutlet ProviderServicesViewController *providerServicesViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

-(IBAction) showServices:(id)sender;

-(void) makeShowServicesButtonVisible:(BOOL)visible;

@end
