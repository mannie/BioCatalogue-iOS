//
//  DetailViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController_iPad.h"
#import "LatestServicesViewController_iPad.h"


@implementation DetailViewController_iPad

@synthesize popoverController, loadingText;


#pragma mark -
#pragma mark Helpers

-(void) startAnimatingActivityIndicators {
  [defaultActivityIndicator startAnimating];
  [serviceDetailActivityIndicator startAnimating];
}

-(void) stopAnimatingActivityIndicators {
  [defaultActivityIndicator stopAnimating];
  [serviceDetailActivityIndicator stopAnimating];
}


#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setLoadingText:(NSString *)newLoadingText {
  if (loadingText != newLoadingText) {
    [loadingText release];
    loadingText = [newLoadingText retain];
    
    // Update the view.
    loadingTextLabel.text = [NSString stringWithFormat:@"Loading: %@", [loadingText description]];
  }
  
  self.view = defaultView;
    
  if (popoverController != nil) {
    [popoverController dismissPopoverAnimated:YES];
  }        
}

-(void) updateWithProperties:(NSDictionary *)properties withScope:(NSString *)scope {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  // fetch the latest properties
  [listingProperties release];
  listingProperties = [properties copy];
  nameLabel.text = [listingProperties objectForKey:JSONNameElement];
  
  NSString *name, *detail;
  
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  
  if ([scope isEqualToString:ServicesSearchScope]) {    // service details
    detail = [NSString stringWithFormat:@"%@", [listingProperties objectForKey:JSONDescriptionElement]];
    descriptionAvailable = ![detail isEqualToString:JSONNull];
    descriptionLabel.text = (descriptionAvailable ? detail : @"No description");
    
    [serviceProperties release];
    serviceProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    
    // provider details
    name = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
             objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
    providerNameLabel.text = name;
    providerDescriptionLabel.text = [NSString stringWithFormat:@"%@",
                                     [[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] objectForKey:JSONProviderElement]];
    
    id country = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                   objectForKey:JSONLocationElement] objectForKey:JSONCountryElement];
    countryFlagIcon.image = ([[NSString stringWithFormat:@"%@", country] isEqualToString:JSONNull] ? 
                             nil : [UIImage imageNamed:@"59-flag.png"]);
    
    // monitoring details
    NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                             [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement]];
    monitoringStatusInformationAvailable = ![lastChecked isEqualToString:JSONNull];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[[JSON_Helper helper] documentAtPath:[userURL path]] copy];

    submitterNameLabel.text = [userProperties objectForKey:JSONNameElement];
    submitterInfoLabel.text = [NSString stringWithFormat:@"%@", userProperties];
    
    self.view = serviceDetailView;
  } else if ([scope isEqualToString:UsersSearchScope]) {
    [userProperties release];
    userProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    self.view = defaultView;
    loadingTextLabel.text = [NSString stringWithFormat:@"%@", userProperties];
  } else {
    [providerProperties release];
    providerProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    self.view = defaultView;
    loadingTextLabel.text = [NSString stringWithFormat:@"%@", providerProperties];
  }

  [self stopAnimatingActivityIndicators];
  
  [autoreleasePool drain];
} // updateWithProperties

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:ServicesSearchScope];
} // updateWithPropertiesForServicesScope

-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:UsersSearchScope];  
} // updateWithPropertiesForUsersScope

-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:ProvidersSearchScope];  
} // updateWithPropertiesForProvidersScope


#pragma mark -
#pragma mark Split view support

-(void) updateCurrentToolbar {
  if (self.view == defaultView) {
    currentToolbar = defaultToolbar;
  } else {
    currentToolbar = serviceDetailToolbar;
  }
} // updateCurrentToolbar

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Main Menu";
  
  [self updateCurrentToolbar];
  
  NSMutableArray *items = [[currentToolbar items] mutableCopy];
  [items insertObject:barButtonItem atIndex:0];
  [currentToolbar setItems:items animated:YES];
  [items release];
  
  self.popoverController = pc;
} // splitViewController:willHideViewController:withBarButtonItem:forPopoverController

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  [self updateCurrentToolbar];
  
  NSMutableArray *items = [[currentToolbar items] mutableCopy];
  [items removeObjectAtIndex:0];
  [currentToolbar setItems:items animated:YES];
  [items release];
  
  self.popoverController = nil;
} // splitViewController:willShowViewController:invalidatingBarButtonItem


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


#pragma mark -
#pragma mark View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view = defaultView;
  
  monitoringStatusInformationAvailable = NO;
  descriptionAvailable = NO;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

/*
 - (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
 }
 */

- (void)dealloc {
  [popoverController release];
  
  [loadingText release];

  [super dealloc];
}


@end
