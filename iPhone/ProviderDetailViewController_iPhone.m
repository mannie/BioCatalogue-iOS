//
//  ProviderDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProviderDetailViewController_iPhone.h"


@implementation ProviderDetailViewController_iPhone

#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {  
  name.text = [properties objectForKey:JSONNameElement];
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  descriptionTextView.text = ([description isValidJSONValue] ? description : NoInformationText);
  
  [providerProperties release];
  providerProperties = [properties copy];
} // updateWithProperties


#pragma mark -
#pragma mark  IBActions

-(void) showServices:(id)sender {
  
}


#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self makeShowServicesButtonVisible:YES];
} // viewDidLoad

// Override to allow orientations other than the default portrait orientation.
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
  [name release];
  [descriptionTextView release];
  
  [servicesButton release];
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  [super viewDidUnload];

  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  [providerProperties release];
  
  [super dealloc];
} // dealloc


@end
