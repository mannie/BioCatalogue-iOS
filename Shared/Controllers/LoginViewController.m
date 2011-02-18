//
//  LoginViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize protectedResourceController;


#pragma mark -
#pragma mark Helpers

-(void) updateView {
  BOOL userDidAuthenticate = [BioCatalogueClient userIsAuthenticated];

  if (userDidAuthenticate) [self showProtectedResource];
  
  usernameField.hidden = userDidAuthenticate;
  passwordField.hidden = userDidAuthenticate;
  signInButton.hidden = userDidAuthenticate;

  signOutButton.hidden = !userDidAuthenticate;
  showProtectedResourceButton.hidden = !userDidAuthenticate;
} // updateView

-(void) setEnabledForUILoginElements:(NSNumber *)enabled {
  float newLoginElementsAlpha;
  if ([enabled boolValue]) {
    [activityIndicator stopAnimating];
    newLoginElementsAlpha = 1;
  } else {
    [activityIndicator startAnimating];
    newLoginElementsAlpha = 0.4;
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    usernameField.alpha = newLoginElementsAlpha;
    passwordField.alpha = newLoginElementsAlpha;
    signInButton.alpha = newLoginElementsAlpha;
  }];
  
  usernameField.enabled = [enabled boolValue];
  passwordField.enabled = [enabled boolValue];
  signInButton.enabled = [enabled boolValue];  
} // setEnabledForUILoginElements

-(void) showUIAlertViewWithErrorMessage:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];
} // showUIAlertViewWithErrorMessage

-(void) attemptToSignInWithUsername:(NSString *)username 
                        andPassword:(NSString *)password
            updatingUILoginElements:(BOOL)updateUI {
  dispatch_async(dispatch_queue_create("Login", NULL), ^{
    if (![BioCatalogueClient signInWithUsername:username withPassword:password]) {
      NSString *message = [NSString stringWithFormat:@"%@\n\n%@", 
                           @"Could not sign into the BioCatalogue.",
                           @"Please check your username and password, and try again."];
      [self performSelectorOnMainThread:@selector(showUIAlertViewWithErrorMessage:) withObject:message waitUntilDone:NO];
    }
    
    [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
    
    if (updateUI) {
      [self performSelectorOnMainThread:@selector(setEnabledForUILoginElements:) 
                             withObject:[NSNumber numberWithBool:YES]
                          waitUntilDone:NO];      
    } else {
      [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    }
  });
} // attemptToSignIn


#pragma mark -
#pragma mark IBActions

-(IBAction) signInToBioCatalogue {
  if (![usernameField.text isValidEmailAddress]) {
    [self showUIAlertViewWithErrorMessage:@"Please enter a valid email address"];
  } else if (![passwordField.text isValidJSONValue]) {
    [self showUIAlertViewWithErrorMessage:@"Please enter a valid password"];
  } else {    
    [self setEnabledForUILoginElements:[NSNumber numberWithBool:NO]];
    [self attemptToSignInWithUsername:usernameField.text andPassword:passwordField.text updatingUILoginElements:YES];
  }
} // signInToBioCatalogue

-(IBAction) signOutOfBioCatalogue {
  [BioCatalogueClient signOutOfBioCatalogue];
  [self updateView];
} // signOutOfBioCatalogue

-(IBAction) showProtectedResource {
  if ([[[self navigationController] viewControllers] count] > 1) {
    NSMutableArray *controllers = [[self.navigationController.viewControllers mutableCopy] autorelease];
    [controllers removeLastObject];
    self.navigationController.viewControllers = controllers;
  }
  
  [self.navigationController pushViewController:protectedResourceController animated: YES];      
} // showProtectedResource


#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib {
  [super awakeFromNib];
  
  // Get the saved authentication, if any, from the keychain.
  NSError *error = nil;
  NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:LastLoggedInUserKey];
  if ([username isValidEmailAddress]) {
    NSString *password = [SFHFKeychainUtils getPasswordForUsername:username
                                                    andServiceName:AppServiceName
                                                             error:&error];
    if (error) [error log];
    
    if ([password isValidJSONValue]) {
      [self attemptToSignInWithUsername:username andPassword:password updatingUILoginElements:NO];
    }    
  }
} // awakeFromNib

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self updateView];
} // viewWillAppear

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation

 
#pragma mark -
#pragma mark Text Field delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
} // textFieldShouldReturn


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [usernameField release];
  [passwordField release];
  
  [signInButton release];
  [signOutButton release];
  
  [showProtectedResourceButton release];
  
  [activityIndicator release];
} // releaseIBOutlets

- (void)dealloc {
  [protectedResourceController release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
