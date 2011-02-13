//
//  MyStuffViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 09/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentController.h"
#import "BioCatalogueClient.h"

#import "NSString+Helper.h"


@interface MyStuffViewController : UITableViewController <UITextFieldDelegate> {
  NSArray *userFavourites;
  NSArray *userSubmissions;
  NSArray *userResponsibilities;
  
  BOOL userDidAuthorize;
  
  IBOutlet UIView *loginView;
  IBOutlet UITextField *usernameField;
  IBOutlet UITextField *passwordField;
  IBOutlet UIButton *signInButton;
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

-(IBAction) signInToBioCatalogue;

@end
