//
//  AnnouncementDetailViewController_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//


@interface AnnouncementDetailViewController_iPhone : UIViewController <UIActionSheetDelegate> {
  IBOutlet UIContentController *uiContentController;

  BOOL viewHasBeenUpdated;
  NSUInteger currentAnnouncementID;
}

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID;

@end
