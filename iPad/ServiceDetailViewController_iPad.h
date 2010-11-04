//
//  ServiceDetailViewController_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 04/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceDetailViewController_iPad : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {

  UIPopoverController *popoverController;
  UIToolbar *toolbar;
  
  id detailItem;
  UILabel *detailDescriptionLabel;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) id detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;

@end
