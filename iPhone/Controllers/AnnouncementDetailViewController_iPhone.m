//
//  AnnouncementDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation AnnouncementDetailViewController_iPhone


#pragma mark -
#pragma mark Helpers

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {
  currentAnnouncementID = announcementID;
  [uiContentController updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:announcementID];
} // updateWithPropertiesForAnnouncementWithID


#pragma mark -
#pragma mark View lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;;
}

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && currentAnnouncementID) [self updateWithPropertiesForAnnouncementWithID:currentAnnouncementID];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [uiContentController release];
  [super dealloc];
}


@end
