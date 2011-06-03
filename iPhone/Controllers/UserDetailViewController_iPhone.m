//
//  UserDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation UserDetailViewController_iPhone


typedef enum { MailThis, Cancel } ActionSheetIndex; // ordered UPWARDS on display

#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {
  [userProperties release];
  userProperties = [properties retain];
  
  [uiContentController updateUserUIElementsWithProperties:userProperties];
  
  viewHasBeenUpdated = YES;
} // updateWithProperties

-(IBAction) composeMailMessageToUser:(id)sender {
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

-(void) showActionSheet:(id)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Mail this to...", nil];
  [actionSheet showFromBarButtonItem:sender animated:YES];
  [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == Cancel) return;
  
  NSString *resource = [@" " stringByAppendingString:[UserResourceScope printableResourceScope]];
  
  // user url is in a different location depending on action performed
  NSURL *url = [NSURL URLWithString:[userProperties objectForKey:JSONSelfElement]]; // via service view
  if (url == nil) url = [NSURL URLWithString:[userProperties objectForKey:JSONResourceElement]]; // via search
  NSString *message = [NSString generateInterestedInMessage:resource withURL:url];
  
  NSString *subject = [NSString stringWithFormat:@"BioCatalogue%@: %@", resource, [userProperties objectForKey:JSONNameElement]];
  [uiContentController composeMailMessage:nil subject:subject content:message];  
}


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && userProperties) [self updateWithProperties:userProperties];

  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
  [[self navigationItem] setRightBarButtonItem:item animated:YES];
  [item release];

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
