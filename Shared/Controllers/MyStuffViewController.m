//
//  MyStuffViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 09/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyStuffViewController.h"


@implementation MyStuffViewController

typedef enum { UserFavourites, UserSubmissions, UserResponsibilities } Section;


#pragma mark -
#pragma mark Helpers

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


#pragma mark -
#pragma mark IBActions

-(IBAction) signInToBioCatalogue {
  if (![usernameField.text isValidEmailAddress]) {
    [self showUIAlertViewWithErrorMessage:@"Please enter a valid email address"];
  } else if (![passwordField.text isValidJSONValue]) {
    [self showUIAlertViewWithErrorMessage:@"Please enter a valid password"];
  } else {    
    [self setEnabledForUILoginElements:[NSNumber numberWithBool:NO]];
    
    dispatch_async(dispatch_queue_create("Login", NULL), ^{
      userDidAuthorize = [BioCatalogueClient signInWithUsername:usernameField.text withPassword:passwordField.text];
      if (!userDidAuthorize) {
        NSString *message = [NSString stringWithFormat:@"%@\n\n%@", 
                             @"Could not sign into the BioCatalogue.",
                             @"Please check your username and password, and try again."];
        [self performSelectorOnMainThread:@selector(showUIAlertViewWithErrorMessage:) withObject:message waitUntilDone:NO];
        
        [self performSelectorOnMainThread:@selector(setEnabledForUILoginElements:) 
                               withObject:[NSNumber numberWithBool:YES]
                            waitUntilDone:NO];      
      }
    });
  }
} // signInToBioCatalogue


#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib {
  // Get the saved authentication, if any, from the keychain.
  GTMOAuthAuthentication *auth = [BioCatalogueClient OAuthAuthentication];
  if (auth) {
    userDidAuthorize = [GTMOAuthViewControllerTouch authorizeFromKeychainForName:OAuthAppServiceName authentication:auth];
    // if the auth object contains an access token, didAuth is now true
  }
  
  // retain the authentication object, which holds the auth tokens
  //
  // we can determine later if the auth object contains an access token
  // by calling its -canAuthorize method
//  [self setAuthentication:auth];
  
//  BOOL isSignedIn = [auth canAuthorize]; // returns NO if auth cannot authorize requests
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController customiseTableView:self.tableView];
//  if (!userDidAuthorize) [self signInToBioCatalogue];
} // viewDidLoad

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
//  favouritedServices = [[BioCatalogueResourceManager currentUserFavouritedServices] retain];
//  submittedServices = [[BioCatalogueResourceManager currentUserSubmittedServices] retain];

  loginView.hidden = userDidAuthorize;
//  if (!userDidAuthorize) [self signInToBioCatalogue];

  [[self tableView] reloadData];
} // viewWillAppear

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (userDidAuthorize) {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    return 3;
  } else {
    [[self tableView] setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return 0;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case UserFavourites: return [userFavourites count];
    case UserSubmissions: return [userSubmissions count];
    case UserResponsibilities: return [userResponsibilities count];
    default: return 0;
  }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case UserFavourites: return @"My Favourite Services";
    case UserSubmissions: return @"Services I Submitted";
    case UserResponsibilities: return @"Services I Am Responsible For";
    default: return nil;
  }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Text Field delegate

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [loginView release];
  [usernameField release];
  [passwordField release];
  [signInButton release];
  [activityIndicator release];
}

- (void)viewDidUnload {
  [userFavourites release];
  [userSubmissions release];
  [userResponsibilities release];

	[super viewDidUnload];
}

- (void)dealloc {
  [userFavourites release];
  [userSubmissions release];
  [userResponsibilities release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
}


@end

