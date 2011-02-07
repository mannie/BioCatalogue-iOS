//
//  ServiceComponentsDetailViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ServiceComponentsDetailViewController.h"


@implementation ServiceComponentsDetailViewController


#pragma mark -
#pragma mark Helpers

-(void) loadRESTMethodDetailView {
  [self loadView];
  self.view = restMethodDetailView;
}

-(void) loadSOAPOperationDetailView {
  [self loadView];
  self.view = soapOperationDetailView;  
}


#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 return YES;
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [restMethodDetailView release];
  [soapOperationDetailView release];
} 

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseIBOutlets];
}


- (void)dealloc {
  [self releaseIBOutlets];
  [super dealloc];
}


@end
