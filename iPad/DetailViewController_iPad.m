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

@synthesize loadingText;


#pragma mark -
#pragma mark Helpers

// TODO: move this to a helper class
-(void) startAnimatingActivityIndicators {
  [activityIndicator startAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  
  serviceNameLabel.alpha = 0.1;
  
  [UIView commitAnimations];
} // startAnimatingActivityIndicators

// TODO: move this to a helper class
-(void) stopAnimatingActivityIndicators {
  [activityIndicator stopAnimating];

  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  
  serviceNameLabel.alpha = 1;
  
  [UIView commitAnimations];
} // stopAnimatingActivityIndicators


#pragma mark -
#pragma mark Managing loading

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
-(void) setLoadingText:(NSString *)newLoadingText {
  if (loadingText != newLoadingText) {
    [loadingText release];
    loadingText = [newLoadingText retain];
    
    // Update the view.
    loadingTextLabel.text = [NSString stringWithFormat:@"Loading: %@", [loadingText description]];
  }
  
  containerTableView.tableHeaderView = defaultView;
  
  if (defaultPopoverController != nil) {
    [defaultPopoverController dismissPopoverAnimated:YES];
  }        
} // setLoadingText


-(void) setDescription:(NSString *)description {
  NSString *desc = [NSString stringWithFormat:@"%@", description];
  BOOL descriptionAvailable = ![desc isEqualToString:@""] && ![desc isEqualToString:JSONNull];

  serviceDescriptionLabel.text = (descriptionAvailable ? desc : @"No description available");
//  providerDescriptionLabel.text = (descriptionAvailable ? desc : @"No information available");
} // setDescription

-(void) updateWithProperties:(NSDictionary *)properties withScope:(NSString *)scope {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  // fetch the latest properties
  [listingProperties release];
  listingProperties = [properties copy];
    
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  
  NSString *detailItem;
  if ([scope isEqualToString:ServicesSearchScope]) {
    serviceNameLabel.text = [listingProperties objectForKey:JSONNameElement];
    
    [serviceProperties release];
    serviceProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    
    // provider details
    detailItem = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
             objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
    serviceProviderNameLabel.text = detailItem;
    
    // monitoring details
    NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                             [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement]];
    monitoringStatusInformationAvailable = ![lastChecked isEqualToString:JSONNull];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[[JSON_Helper helper] documentAtPath:[userURL path]] copy];
    
    serviceSubmitterNameLabel.text = [userProperties objectForKey:JSONNameElement];
  } else if ([scope isEqualToString:UsersSearchScope]) {
    [userProperties release];
//    userProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    userProperties = [properties copy];
    
    userNameLabel.text = [userProperties objectForKey:JSONNameElement];

    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
    userAffiliationLabel.text = ([detailItem isEqualToString:@""] || [detailItem isEqualToString:JSONNull] ? @"Unknown" : detailItem);
    
    detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCountryElement]];
    userCountryLabel.text = ([detailItem isEqualToString:@""] || [detailItem isEqualToString:JSONNull] ? @"Unknown" : detailItem);
    
    detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCityElement]];
    userCityLabel.text = ([detailItem isEqualToString:@""] || [detailItem isEqualToString:JSONNull] ? @"Unknown" : detailItem);
    
    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONPublicEmailElement]];
    userEmailLabel.text = ([detailItem isEqualToString:@""] || [detailItem isEqualToString:JSONNull] ? @"Unknown" : detailItem);
    
    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONJoinedElement]];
    userJoinedLabel.text = [detailItem stringByReplacingCharactersInRange:NSMakeRange(10, 10) withString:@""];
  } else {
    [providerProperties release];
//    providerProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    providerProperties = [properties copy];
    
    providerNameLabel.text = [providerProperties objectForKey:JSONNameElement];

    detailItem = [NSString stringWithFormat:@"%@", [providerProperties objectForKey:JSONDescriptionElement]];
    providerDescriptionLabel.text = ([detailItem isEqualToString:@""] || [detailItem isEqualToString:JSONNull] ? @"No information available" : detailItem);
  }
  
  // TODO: move this to a helper class
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *lastSavedProperties = [defaults dictionaryForKey:LastViewedResourceKey];
  NSString *lastSavedScope = [defaults stringForKey:LastViewedResourceScopeKey];
  
  [defaults setObject:properties forKey:LastViewedResourceKey];
  [defaults setObject:scope forKey:LastViewedResourceScopeKey];
  
  if (![defaults objectForKey:LastViewedResourceKey]) {
    // failed to store new object so revert to last stored one
    [defaults setObject:lastSavedProperties forKey:LastViewedResourceKey];
    [defaults setObject:lastSavedScope forKey:LastViewedResourceScopeKey];
  }
  
  [self stopAnimatingActivityIndicators];
  
  [autoreleasePool drain];
} // updateWithProperties:scope

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties {  
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

  [self updateWithProperties:properties withScope:ServicesSearchScope];
  containerTableView.tableHeaderView = serviceDetailView;
  scopeOfResourceBeingViewed = ServicesSearchScope;

  [autoreleasePool drain];
} // updateWithPropertiesForServicesScope

-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

  [self updateWithProperties:properties withScope:UsersSearchScope];  
  containerTableView.tableHeaderView = userDetailView;
  scopeOfResourceBeingViewed = UsersSearchScope;

  [autoreleasePool drain];
} // updateWithPropertiesForUsersScope

-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];

  [self updateWithProperties:properties withScope:ProvidersSearchScope];  
  containerTableView.tableHeaderView = providerDetailView;
  scopeOfResourceBeingViewed = ProvidersSearchScope;

  [autoreleasePool drain];
} // updateWithPropertiesForProvidersScope


#pragma mark -
#pragma mark IBActions

-(void) viewSubmitterInformation:(id)sender {
/*
  userDetailIDCardView.alpha = 0;
  
  containerTableView.tableFooterView = userDetailIDCardView;
  
  [self updateWithProperties:userProperties withScope:UsersSearchScope];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.5];
  userDetailIDCardView.alpha = 1;
  [UIView commitAnimations];
*/  
  
  /*
  UIViewController *viewController = [[UIViewController alloc] init];
  viewController.view = userDetailIDCardView;
  
  // TODO: store current service?
  
  // TODO: load up user into popover
  [self updateWithProperties:userProperties withScope:UsersSearchScope];
  
  if (!contextualPopoverController.popoverVisible) {
    [contextualPopoverController release];
    contextualPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    [contextualPopoverController presentPopoverFromRect:[sender frame]
                                                 inView:serviceDetailView 
                               permittedArrowDirections:UIPopoverArrowDirectionUp
                                               animated:YES];    
    [contextualPopoverController setPopoverContentSize:userDetailIDCardView.frame.size animated:YES];
  }
   */
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Main Menu";

  NSMutableArray *items = [[toolbar items] mutableCopy];

  favouriteServiceBarButtonItem.enabled = [scopeOfResourceBeingViewed isEqualToString:ServicesSearchScope];
  
  [items insertObject:barButtonItem atIndex:0];
  [toolbar setItems:items animated:YES];

  [items release];
  
  defaultPopoverController = pc;
} // splitViewController:willHideViewController:withBarButtonItem:forPopoverController

- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  NSMutableArray *items = [[toolbar items] mutableCopy];
  [items removeObjectAtIndex:0]; 
  [toolbar setItems:items animated:YES];  
  [items release];
  
  defaultPopoverController = nil;
} // splitViewController:willShowViewController:invalidatingBarButtonItem


#pragma mark -
#pragma mark View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
} // viewDidLoad

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (!viewHasAlreadyInitialized) {
    NSDictionary *properties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LastViewedResourceKey];
    NSString *scope = [[NSUserDefaults standardUserDefaults] stringForKey:LastViewedResourceScopeKey];

    self.loadingText = [properties objectForKey:JSONNameElement];
    if ([scope isEqualToString:ServicesSearchScope]) {
      [self setDescription:[properties objectForKey:JSONDescriptionElement]];

      // FIXME: threading issues
      [self updateWithPropertiesForServicesScope:properties];
//      [NSThread detachNewThreadSelector:@selector(updateWithPropertiesForServicesScope:) 
//                               toTarget:self
//                             withObject:properties];
    } else if ([scope isEqualToString:UsersSearchScope]) {
      [self updateWithPropertiesForUsersScope:properties];
    } else {
      [self setDescription:[properties objectForKey:JSONDescriptionElement]];
      [self updateWithPropertiesForProvidersScope:properties];
    }
    
    UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                                              action:@selector(panViewButResetPositionAfterwards:)];
    [userDetailIDCardView addGestureRecognizer:recognizer];
    [providerDetailIDCardView addGestureRecognizer:recognizer];
    [recognizer release];
    
    viewHasAlreadyInitialized = YES;
  }  
} // viewWillAppear

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  return 0;
} // tableView:numberOfRowsInSection

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  // default view outlets
  [toolbar release];
  [defaultView release];  
  [activityIndicator release];
  
  // service view outlets
  [serviceDetailView release];
  
  [serviceNameLabel release];
  [serviceDescriptionLabel release];
  [serviceProviderNameLabel release];
  [serviceSubmitterNameLabel release];
  
  // user view outlets  
  [userDetailView release];
  
  [userDetailIDCardView release];
  
  [userNameLabel release];
  [userAffiliationLabel release];
  [userCountryLabel release];
  [userCityLabel release];
  [userEmailLabel release];
  [userJoinedLabel release];
  
  // provider view outlets
  [providerDetailView release];
  [providerDetailIDCardView release];
  
  [providerNameLabel release];
  [providerDescriptionLabel release];

  // other outlets
  [loadingTextLabel release];
  [containerTableView release];
  [gestureHandler release];
  
  [favouriteServiceBarButtonItem release];
  [viewResourceInBioCatalogueBarButtonItem release];
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  [defaultPopoverController release];
  [contextualPopoverController release];

  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [defaultPopoverController release];
  [contextualPopoverController release];
  
  [loadingText release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
