//
//  UserDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface UserDetailViewController_iPhone : UIViewController {  
  IBOutlet UIContentController *uiContentController;
  
  NSDictionary *userProperties;

  BOOL viewHasBeenUpdated;
}

-(void) updateWithProperties:(NSDictionary *)properties;

@end
