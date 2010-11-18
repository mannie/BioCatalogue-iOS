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
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  nameLabel.alpha = 0.1;
  [UIView commitAnimations];
} // startAnimatingActivityIndicators

-(void) stopAnimatingActivityIndicators {
  [defaultActivityIndicator stopAnimating];
  [serviceDetailActivityIndicator stopAnimating];
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  nameLabel.alpha = 1;
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
  
  componentsTableView.tableHeaderView = defaultView;
  
  if (popoverController != nil) {
    [popoverController dismissPopoverAnimated:YES];
  }        
} // setLoadingText


-(void) setServiceDescription:(NSString *)description {
  NSString *desc = [NSString stringWithFormat:@"%@", description];
  descriptionAvailable = ![desc isEqualToString:JSONNull];
  descriptionLabel.text = (descriptionAvailable ? desc : @"No service description");
} // setServiceDescription

-(void) updateWithProperties:(NSDictionary *)properties withScope:(NSString *)scope {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  // fetch the latest properties
  [listingProperties release];
  listingProperties = [properties copy];
  nameLabel.text = [listingProperties objectForKey:JSONNameElement];
  
  NSString *name;
  
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  
  if ([scope isEqualToString:ServicesSearchScope]) {
    [serviceProperties release];
    serviceProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    
    // provider details
    name = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
             objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
    providerNameLabel.text = name;
    
    // monitoring details
    NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                             [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement]];
    monitoringStatusInformationAvailable = ![lastChecked isEqualToString:JSONNull];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[[JSON_Helper helper] documentAtPath:[userURL path]] copy];
    
    submitterNameLabel.text = [userProperties objectForKey:JSONNameElement];

    componentsTableView.tableHeaderView = serviceDetailView;
  } else if ([scope isEqualToString:UsersSearchScope]) {
    [userProperties release];
    userProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    componentsTableView.tableHeaderView = defaultView;
    loadingTextLabel.text = [NSString stringWithFormat:@"%@", userProperties];
  } else {
    [providerProperties release];
    providerProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
    componentsTableView.tableHeaderView = defaultView;
    loadingTextLabel.text = [NSString stringWithFormat:@"%@", providerProperties];
  }
    
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

-(NSArray *) listOfToolbarsInNib {
  if (componentsTableView.tableHeaderView == serviceDetailView) {
    return [NSArray arrayWithObjects:defaultToolbar, serviceDetailToolbar, nil];
  } else {
    return [NSArray arrayWithObjects:serviceDetailToolbar, defaultToolbar, nil];
  }
} // listOfToolbarsInNib

- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Main Menu";
  
  for (UIToolbar *toolbar in [self listOfToolbarsInNib]) {
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];    
  }

  self.popoverController = pc;
} // splitViewController:willHideViewController:withBarButtonItem:forPopoverController

- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
  for (UIToolbar *toolbar in [self listOfToolbarsInNib]) {
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];  
    [items release];
  }

  self.popoverController = nil;
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
    if ([scope isEqualToString:ServicesSearchScope]) {
      [self setServiceDescription:[properties objectForKey:JSONDescriptionElement]];
    }
    
    [self updateWithProperties:properties withScope:scope];
    
    viewHasAlreadyInitialized = YES;
    
    gestureHandler = [[GestureHandler alloc] init];
    
    UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                                              action:@selector(panViewButResetPositionAfterwards:)];
    [self.view addGestureRecognizer:recognizer];
    [recognizer release];
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
  [defaultToolbar release];
  [serviceDetailToolbar release];
  
  [loadingTextLabel release];
  
  [defaultView release];
  [serviceDetailView release];
  [nameLabel release];
  [descriptionLabel release];
  [providerNameLabel release];
  [submitterNameLabel release];
  
  [defaultActivityIndicator release];
  [serviceDetailActivityIndicator release];
  
  [componentsTableView release];
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
 // Releases the view if it doesn't have a superview.
 [super didReceiveMemoryWarning];
 
 // Release any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Release any retained subviews of the main view.
  self.popoverController = nil;
  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [popoverController release];
  
  [gestureHandler release];
  [loadingText release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
