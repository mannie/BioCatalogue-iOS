//
//  UserDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserDetailViewController_iPhone.h"


@implementation UserDetailViewController_iPhone

#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {
  [userProperties release];
  userProperties = [properties retain];
  
  nameLabel.text = [userProperties objectForKey:JSONNameElement];
  
  NSString *detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
  affiliationLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCountryElement]];
  countryLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCityElement]];
  cityLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONPublicEmailElement]];
  emailLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONJoinedElement]];
  joinedLabel.text = [detailItem stringByReplacingCharactersInRange:NSMakeRange(10, 10) withString:@""];
} // updateWithProperties


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && userProperties) [self updateWithProperties:userProperties];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [nameLabel release];
  [affiliationLabel release];
  [countryLabel release];
  [cityLabel release];
  [emailLabel release];
  [joinedLabel release];
} // releaseIBOutlets

- (void)dealloc {
  [userProperties release];
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
