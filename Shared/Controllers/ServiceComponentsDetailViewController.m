//
//  ServiceComponentsDetailViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation ServiceComponentsDetailViewController


#pragma mark -
#pragma mark Helpers

-(void) loadRESTMethodDetailView {
  if (![self view]) [self loadView];
  [self setView:restMethodDetailView];
}

-(void) loadSOAPOperationDetailView {
  if (![self view]) [self loadView];
  [self setView:soapOperationDetailView];
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

- (void)dealloc {
  [self releaseIBOutlets];
  [super dealloc];
}


@end
