//
//  ProviderDetailViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProviderDetailViewController.h"


@implementation ProviderDetailViewController

@synthesize providerServicesViewController;


#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {
  if (!self.view) [self performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
  
  [providerProperties release];
  providerProperties = [properties retain];
  
  [uiContentController updateProviderUIElementsWithProperties:properties];
  
  viewHasBeenUpdated = YES;
  [self.view setNeedsDisplay];
} // updateWithProperties


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && providerProperties) [self updateWithProperties:providerProperties];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark  IBActions

-(void) showServices:(id)sender {
  [providerServicesViewController loadView];

  NSString *providerID = [[providerProperties objectForKey:JSONResourceElement] lastPathComponent];
  [providerServicesViewController updateWithServicesFromProviderWithID:[providerID intValue]];

  [self.navigationController pushViewController:providerServicesViewController animated:YES];  
} // showServices


#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation

-(void) makeShowServicesButtonVisible:(BOOL)visible {
  if (visible) {
    self.navigationItem.rightBarButtonItem = servicesButton;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
  }
} // makeShowServicesButtonVisible


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [servicesButton release];
  [uiContentController release];
  
  [providerServicesViewController release];
} // releaseIBOutlets

- (void)dealloc {
  [self releaseIBOutlets];
  [providerProperties release];
  
  [super dealloc];
} // dealloc


@end
