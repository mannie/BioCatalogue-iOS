//
//  UserDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConstants.h"
#import "NSString+Helper.h"


@interface UserDetailViewController_iPhone : UIViewController {  
  IBOutlet UILabel *nameLabel;
  IBOutlet UILabel *affiliationLabel;
  IBOutlet UILabel *countryLabel;
  IBOutlet UILabel *cityLabel;
  IBOutlet UILabel *emailLabel;
  IBOutlet UILabel *joinedLabel;
  
  NSDictionary *userProperties;

  BOOL viewHasBeenUpdated;
}

-(void) updateWithProperties:(NSDictionary *)properties;

@end
