//
//  ProviderDetailViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class ProviderServicesViewController;


@interface ProviderDetailViewController : UIViewController <UIWebViewDelegate> {
  IBOutlet UIContentController *uiContentController;

  IBOutlet UIBarButtonItem *servicesButton;

  NSDictionary *providerProperties;
  
  ProviderServicesViewController *providerServicesViewController;
  DetailViewController_iPad *iPadDetailViewController;
  
  BOOL viewHasBeenUpdated;
}

@property(nonatomic, retain) IBOutlet ProviderServicesViewController *providerServicesViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

-(IBAction) showServices:(id)sender;

-(void) makeShowServicesButtonVisible:(BOOL)visible;

@end
