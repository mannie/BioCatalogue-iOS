//
//  FavouritesController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 12/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FavouritesController.h"


@implementation FavouritesController

typedef enum { UserFavourites, UserSubmissions } Section;

static NSInteger UserFavouritesSection = 0;
static NSInteger UserSubmissionsSection = 1;


#pragma mark -
#pragma mark Helpers

- (void)viewController:(GTMOAuthViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuthAuthentication *)auth
                 error:(NSError *)error {
  if (error != nil) {
    // Authentication failed
    NSLog(@"-------Authentication failed: %@", auth);
  } else {
    // Authentication succeeded
    NSLog(@"-------Authentication succeeded: %@", auth);

    // If authentication succeeds, your application should retain the authentication object. 
    // It can be used directly to authorize NSMutableURLRequest objects:
    // [auth authorizeRequest:myNSURLMutableRequest];
  }
} // viewController:finishedWithAuth:error

- (void)signInToBioCatalogue {
  NSString *scope = [[BioCatalogueClient URLForPath:@"/services" withRepresentation:JSONFormat] absoluteString];
  
  // set the callback URL to which the site should redirect, and for which
  // the OAuth controller should look to determine when sign-in has
  // finished or been canceled
  //
  // This URL does not need to be for an actual web page
  GTMOAuthAuthentication *authentication = [BioCatalogueClient clientOAuthAuthentication];
  [authentication setCallback:[[BioCatalogueClient OAuthCallbackURL] absoluteString]];
  
  // Display the autentication view
  GTMOAuthViewControllerTouch *viewController;
  viewController = [[GTMOAuthViewControllerTouch alloc] initWithScope:scope
                                                             language:nil
                                                      requestTokenURL:[BioCatalogueClient OAuthRequestURL]
                                                    authorizeTokenURL:[BioCatalogueClient OAuthAuthorizeURL]
                                                       accessTokenURL:[BioCatalogueClient OAuthAccessURL]
                                                       authentication:authentication
                                                       appServiceName:@"iOS BioCatalogue: Login Service"
                                                             delegate:self
                                                     finishedSelector:@selector(viewController:finishedWithAuth:error:)];
  
  [[self navigationController] pushViewController:[viewController autorelease] animated:YES];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
    
  [UIContentController setTableViewBackground:self.tableView];                                                                          
} // viewDidLoad

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  favouritedServices = [[BioCatalogueResourceManager currentUserFavouritedServices] retain];
  submittedServices = [[BioCatalogueResourceManager currentUserSubmittedServices] retain];
  
  [[self tableView] reloadData];
//  [self signInToBioCatalogue];
} // viewWillAppear

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
} // numberOfSectionsInTableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == UserFavourites) {
    return [favouritedServices count];
  } else {
    return [submittedServices count];
  }
} // tableView:numberOfRowsInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  Service *service;
  if (indexPath.section == UserFavourites) {
    service = [favouritedServices objectAtIndex:indexPath.row];
  } else {
    service = [submittedServices objectAtIndex:indexPath.row];
  }

  [UIContentController customiseTableViewCell:cell withService:service];
  
  return cell;
} // tableView:cellForRowAtIndexPath

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return (section == UserFavourites ? @"My Favourite Services" : @"Services I Submitted");
} // tableView:titleForHeaderInSection


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  [favouritedServices release];
  [submittedServices release];
}


- (void)dealloc {
  [favouritedServices release];
  [submittedServices release];
  
  [super dealloc];
}


@end

