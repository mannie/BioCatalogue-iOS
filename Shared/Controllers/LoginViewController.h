//
//  LoginViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface LoginViewController : UIViewController <UITextFieldDelegate> {
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;

  IBOutlet UIButton *signInButton;  
  IBOutlet UIButton *signOutButton;  

  IBOutlet UIButton *showProtectedResourceButton;  
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet id protectedResourceController;

-(IBAction) signInToBioCatalogue;
-(IBAction) signOutOfBioCatalogue;

-(IBAction) showProtectedResource;

@end
