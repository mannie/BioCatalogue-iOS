//
//  ProviderDetailViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

@class ProviderServicesViewController;


@interface ProviderDetailViewController : UIViewController <UIWebViewDelegate> {
  IBOutlet UIContentController *uiContentController;

  NSDictionary *providerProperties;
  
  ProviderServicesViewController *providerServicesViewController;
  DetailViewController_iPad *iPadDetailViewController;
  
  BOOL viewHasBeenUpdated;
  BOOL servicesDeeperInStackShouldShowProviderButton;
  
  NSUInteger lowerBound;
}

@property(nonatomic, retain) IBOutlet ProviderServicesViewController *providerServicesViewController;

-(void) updateWithProperties:(NSDictionary *)properties;

-(void) showServicesButtonIfGreater:(NSUInteger)value;

@end
