//
//  AnnouncementDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentController.h"


@interface AnnouncementDetailViewController_iPhone : UIViewController {
  IBOutlet UIContentController *uiContentController;

}

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID;

@end
