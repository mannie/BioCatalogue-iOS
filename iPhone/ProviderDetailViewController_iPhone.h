//
//  ProviderDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProviderDetailViewController_iPhone : UIViewController {
  IBOutlet UITextView *textView;
  
  NSDictionary *providerProperties;
}

-(void) updateWithProperties:(NSDictionary *)properties;

@end
