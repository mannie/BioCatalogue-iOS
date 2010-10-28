//
//  ProviderDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppConstants.h"


@interface ProviderDetailViewController_iPhone : UIViewController {
  IBOutlet UILabel *name;
  IBOutlet UITextView *descriptionTextView;

  IBOutlet UIBarButtonItem *servicesButton;

  NSDictionary *providerProperties;
}

-(void) updateWithProperties:(NSDictionary *)properties;

-(IBAction) showServices:(id)sender;

-(void) makeShowServicesButtonVisible:(BOOL)visible;

@end
