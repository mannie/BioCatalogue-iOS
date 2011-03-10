//
//  UserDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation UserDetailViewController_iPhone

#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {
  [userProperties release];
  userProperties = [properties retain];
  
  [uiContentController updateUserUIElementsWithProperties:userProperties];
  
  viewHasBeenUpdated = YES;
} // updateWithProperties

-(IBAction) composeMailMessage:(id)sender {
  NSString *publicEmail = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONPublicEmailElement]];
  
  if ([publicEmail isValidJSONValue]) {
    NSURL *address = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", publicEmail]];
    [uiContentController composeMailMessage:address];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to compose mail"
                                                    message:@"This user does not have a public e-mail address." 
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
} // composeMailMessage


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && userProperties) [self updateWithProperties:userProperties];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [uiContentController release];
} // releaseIBOutlets

- (void)dealloc {
  [userProperties release];
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
