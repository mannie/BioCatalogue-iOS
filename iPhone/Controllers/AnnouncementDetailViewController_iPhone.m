//
//  AnnouncementDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation AnnouncementDetailViewController_iPhone


typedef enum { MailThis, Cancel } ActionSheetIndex; // ordered UPWARDS on display

#pragma mark -
#pragma mark Helpers

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {
  currentAnnouncementID = announcementID;
  [uiContentController updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:announcementID];
} // updateWithPropertiesForAnnouncementWithID

-(void) showActionSheet:(id)sender {
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Mail this to...", nil];
  [actionSheet showFromBarButtonItem:sender animated:YES];
  [actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == Cancel) return;
  
  NSString *resource = [@" " stringByAppendingString:[AnnouncementResourceScope printableResourceScope]];

  NSString *path = [NSString stringWithFormat:@"/%@/%i", AnnouncementResourceScope, currentAnnouncementID];
  NSString *message = [NSString generateInterestedInMessage:resource withURL:[BioCatalogueClient URLForPath:path withRepresentation:nil]];
  
  NSString *subject = [NSString stringWithFormat:@"BioCatalogue%@: %@", 
                       resource, [[BioCatalogueResourceManager announcementWithUniqueID:currentAnnouncementID] title]];
  [uiContentController composeMailMessage:nil subject:subject content:message];  
}


#pragma mark -
#pragma mark View lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;;
}

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && currentAnnouncementID) [self updateWithPropertiesForAnnouncementWithID:currentAnnouncementID];
  
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
  [[self navigationItem] setRightBarButtonItem:item animated:YES];
  [item release];

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
