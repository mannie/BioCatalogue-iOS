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
#pragma mark Helpers and IBActions

-(void) updateWithProperties:(NSDictionary *)properties {  
  name.text = [properties objectForKey:JSONNameElement];
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  if (![description isEqualToString:JSONNull]) {
    descriptionTextView.text = description;
  } else {
    descriptionTextView.text = @"(no description available)";
  }

  [providerProperties release];
  providerProperties = [properties copy];
}

-(void) showServices:(id)sender {
  
}


#pragma mark -
#pragma mark View lifecycle

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self makeShowServicesButtonVisible:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void) makeShowServicesButtonVisible:(BOOL)visible {
  if (visible) {
    self.navigationItem.rightBarButtonItem = servicesButton;
  } else {
    self.navigationItem.rightBarButtonItem = nil;
  }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [providerProperties release];
  
  [super dealloc];
}


@end
