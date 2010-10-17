//
//  UserDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserDetailViewController_iPhone : UIViewController {
  IBOutlet UITextView *textView;
  
  NSDictionary *userProperties;
}

-(void) updateWithProperties:(NSDictionary *)properties;

@end
