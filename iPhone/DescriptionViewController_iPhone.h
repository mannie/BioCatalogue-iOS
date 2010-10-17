//
//  DescriptionViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DescriptionViewController_iPhone : UIViewController {
  UITextView *descriptionTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;

@end
