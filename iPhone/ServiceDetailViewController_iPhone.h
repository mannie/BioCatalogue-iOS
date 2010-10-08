//
//  ServiceDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConstants.h"


@interface ServiceDetailViewController_iPhone : UIViewController {
  IBOutlet UILabel *name;
  IBOutlet UITextView *description;
}

-(void) updateWithProperties:(NSDictionary *)properties;

@end
