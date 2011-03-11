//
//  LoginViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation LoginViewController

@synthesize protectedResourceController;


#pragma mark -
#pragma mark Helpers

-(void) updateView {
  BOOL userDidAuthenticate = [BioCatalogueClient userIsAuthenticated];

  if (userDidAuthenticate) [self showProtectedResource];
  
  [usernameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:LastLoggedInUserKey]];

  [usernameField setHidden:userDidAuthenticate];
  [passwordField setHidden:userDidAuthenticate];
  [signInButton setHidden:userDidAuthenticate];
  
  [signOutButton setHidden:!userDidAuthenticate];
  [showProtectedResourceButton setHidden:!userDidAuthenticate];
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
    [usernameField setAlpha:newLoginElementsAlpha];
    [passwordField setAlpha:newLoginElementsAlpha];
    [signInButton setAlpha:newLoginElementsAlpha];
  }];
  
  [usernameField setEnabled:[enabled boolValue]];
  [passwordField setEnabled:[enabled boolValue]];
  [signInButton setEnabled:[enabled boolValue]];
} // setEnabledForUILoginElements

-(void) attemptToSignInWithUsername:(NSString *)username 
                        andPassword:(NSString *)password
            updatingUILoginElements:(BOOL)updateUI {
  dispatch_async(dispatch_queue_create("Login", NULL), ^{
    [self performSelectorOnMainThread:@selector(updateView) withObject:nil waitUntilDone:NO];
    
    if (![BioCatalogueClient signInWithUsername:username withPassword:password]) {
      [[NSError errorWithDomain:BioCatalogueClientErrorDomain code:LoginError userInfo:nil] log];
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
  if (![[usernameField text] isValidEmailAddress]) {
    [[NSError errorWithDomain:BioCatalogueClientErrorDomain code:InvalidEmailAddressError userInfo:nil] log];
  } else if (![[passwordField text] isValidJSONValue]) {
    [[NSError errorWithDomain:BioCatalogueClientErrorDomain code:InvalidPasswordError userInfo:nil] log];
  } else {    
    [self setEnabledForUILoginElements:[NSNumber numberWithBool:NO]];
    [self attemptToSignInWithUsername:[usernameField text] andPassword:[passwordField text] updatingUILoginElements:YES];
  }
} // signInToBioCatalogue

-(IBAction) signOutOfBioCatalogue {
  [BioCatalogueClient signOutOfBioCatalogue];
  
  [passwordField setText:nil];
  [self updateView];
  
  if ([[[self navigationController] viewControllers] count] > 1) {
    [[self navigationController] setViewControllers:[NSArray arrayWithObject:self]];
  }  
} // signOutOfBioCatalogue

-(IBAction) showProtectedResource {
  if ([[[self navigationController] viewControllers] count] > 1) {
    NSMutableArray *controllers = [[[[self navigationController] viewControllers] mutableCopy] autorelease];
    [controllers removeLastObject];
    [[self navigationController] setViewControllers:controllers];
  }
  
  [[self navigationController] pushViewController:protectedResourceController animated: YES];      
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
      [passwordField setText:password];
      [self setEnabledForUILoginElements:[NSNumber numberWithBool:NO]];
      [self attemptToSignInWithUsername:username andPassword:password updatingUILoginElements:NO];
    }    
  } else {
    [self setEnabledForUILoginElements:[NSNumber numberWithBool:YES]];
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
