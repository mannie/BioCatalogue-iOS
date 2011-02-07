//
//  AnnouncementDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AnnouncementDetailViewController_iPhone.h"


@implementation AnnouncementDetailViewController_iPhone


#pragma mark -
#pragma mark Helpers

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {
  [uiContentController updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:announcementID];
} // updateWithPropertiesForAnnouncementWithID


#pragma mark -
#pragma mark View lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  [uiContentController release];
}


- (void)dealloc {
  [uiContentController release];
  [super dealloc];
}


@end
