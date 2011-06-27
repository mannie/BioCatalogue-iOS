//
//  DetailViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 13/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation DetailViewController_iPad

@synthesize monitoringStatusViewController, serviceComponentsViewController, webBrowserController;

typedef enum { OpenInBioCatalogue, OpenInSafari, MailThis } MainActionSheetIndex; // ordered DOWNWARDS on display
typedef enum { PullOutOpenInSafari, PullOutMailThis } PullOutActionSheetIndex; // ordered DOWNWARDS on display


#pragma mark -
#pragma mark Helpers

-(NSURL *) URLOfResourceBeingViewed {
  NSURL *url;
  if ([scopeOfResourceBeingViewed isEqualToString:AnnouncementResourceScope]) {
    url = [BioCatalogueClient URLForPath:[NSString stringWithFormat:@"/%@/%i", AnnouncementResourceScope, lastAnnouncementID]
                      withRepresentation:nil];
  } else {
    url = [NSURL URLWithString:[listingProperties objectForKey:JSONResourceElement]];
  }
  
  return [url absoluteURL];
} // URLOfResourceBeingViewed

-(NSString *) nameOfResourceBeingViewed {
  if ([scopeOfResourceBeingViewed isEqualToString:AnnouncementResourceScope]) {
    return [[BioCatalogueResourceManager announcementWithUniqueID:lastAnnouncementID] title];
  } else if ([scopeOfResourceBeingViewed isEqualToString:ServiceResourceScope]) {
    return [listingProperties objectForKey:JSONNameElement];
  } else {
    return [[self URLOfResourceBeingViewed] absoluteString];
  }
}

-(void) touchToolbar:(UIToolbar *)toolbar {  
  if (toolbar == mainToolbar) {
    [viewCurrentResourceBarButtonItem setEnabled:scopeOfResourceBeingViewed != nil];
  }
    
  NSArray *items = [toolbar items];
  [toolbar performSelectorOnMainThread:@selector(setItems:) withObject:nil waitUntilDone:NO];
  [toolbar performSelectorOnMainThread:@selector(setItems:animated:) withObject:items waitUntilDone:NO];  
} // touchToolbar

-(BOOL) isCurrentlyBusy {
  return controllerIsCurrentlyBusy;
} // isCurrentlyBusy

-(void) loadViewIntoContextualPopover:(UIView *)myView 
                             intoView:(UIView *)parentView
                   withViewController:(UIViewController *)viewController 
                    withArrowFromRect:(CGRect)rect
                             withSize:(CGSize)size {
  if (myView) {
    viewController = [[[UIViewController alloc] init] autorelease];
    [viewController setView:myView];
  }
  
  [contextualPopoverController release];
  contextualPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
  [contextualPopoverController setDelegate:self];
  [contextualPopoverController setPopoverContentSize:size animated:YES];
  [contextualPopoverController presentPopoverFromRect:rect
                                               inView:parentView
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
} // loadViewIntoContextualPopover:intoView:withViewController:withArrowFromRect:withSize

-(void) startLoadingAnimation {
  [activityIndicator startAnimating];
  [defaultPopoverController dismissPopoverAnimated:YES];
  [self dismissAuxiliaryDetailPanel:self];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [activityIndicator stopAnimating];
} // stopLoadingAnimation

-(void) setContentView:(UIView *)subView forParentView:(UIView *)parentView {  
  [defaultView setHidden:subView != defaultView];
  
  // auxiliary panel
  if (parentView == auxiliaryDetailPanel && currentAuxiliaryPanelView != subView) {
    [currentAuxiliaryPanelView removeFromSuperview];
    [parentView addSubview:subView];
    currentAuxiliaryPanelView = subView;
    
    [webBrowserToolbar setHidden:subView != webBrowser];
    [webBrowser setHidden:subView != webBrowser];
  } 
  
  if (parentView == auxiliaryDetailPanel) [self exposeAuxiliaryDetailPanel:self];
  
  // main content panel
  if (parentView == mainContentView && currentMainContentView != subView) {
    [currentMainContentView removeFromSuperview];
    [parentView addSubview:subView];
    currentMainContentView = subView;
  }
} // setContentView:forParentView


#pragma mark -
#pragma mark Managing loading resources into the view

-(void) updateMarkAsFavouriteToolbarItemForServiceWithUniqueID:(NSUInteger)uniqueID {
  // toolbar update
  UIImage *image;
  if ([BioCatalogueResourceManager serviceWithUniqueIDIsFavourited:uniqueID]) {
    image = [UIImage imageNamed:ServiceStarredIcon];
  } else {
    image = [UIImage imageNamed:ServiceUnstarredIcon];
  }  
  
  NSMutableArray *items = [[[mainToolbar items] mutableCopy] retain];
  int indexOfReplacement = [items count] - 1 - 2;

  [items removeObjectAtIndex:indexOfReplacement];
  [favouriteServiceBarButtonItem release];
  
  favouriteServiceBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(markUnmarkServiceAsFavourite:)];
  [items insertObject:favouriteServiceBarButtonItem atIndex:indexOfReplacement];
  [mainToolbar setItems:items animated:NO];
  [items release];
}

-(void) preUpdateWithPropertiesActionsForServices:(NSDictionary *)properties {  
  // TODO: uncomment next line; this was commented out for demo purposes since the favouriting was not going to be demoed
//  [self updateMarkAsFavouriteToolbarItemForServiceWithUniqueID:[[[properties objectForKey:JSONResourceElement] lastPathComponent] intValue]];
  
  // main view update
  [uiContentController updateServiceUIElementsWithProperties:properties
                                                providerName:nil 
                                               submitterName:nil
                                             showLoadingText:YES];
  
  // monitoring details
  NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                           [[properties objectForKey:JSONLatestMonitoringStatusElement] 
                            objectForKey:JSONLastCheckedElement]];
  monitoringStatusInformationAvailable = [lastChecked isValidJSONValue];
  
  int serviceID = [[[properties objectForKey:JSONResourceElement] lastPathComponent] intValue];
  if ([BioCatalogueResourceManager serviceWithUniqueIDIsBeingMonitored:serviceID]) {
    Service *service = [BioCatalogueResourceManager serviceWithUniqueID:serviceID];
    
    if ([[service hasUpdate] boolValue]) {
      [service setHasUpdate:[NSNumber numberWithBool:NO]];
      [BioCatalogueResourceManager commitChanges];
      
      [UpdateCenter performSelectorOnMainThread:@selector(updateApplicationBadgesForServiceUpdates) withObject:nil waitUntilDone:NO];
    }
  }  
} // preUpdateWithPropertiesActionsForServices

-(void) postUpdateWithPropertiesActionsForServices {
  NSString *provider = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                         objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
  
  [uiContentController updateServiceUIElementsWithProperties:nil
                                                providerName:provider
                                               submitterName:[userProperties objectForKey:JSONNameElement]
                                             showLoadingText:NO];
  
  [self setContentView:serviceDetailView forParentView:mainContentView];
  [self stopLoadingAnimation];
} // postUpdateWithPropertiesActionsForServices

-(void) updateWithProperties:(NSDictionary *)properties withScope:(NSString *)scope {
  controllerIsCurrentlyBusy = YES;
  
  // fetch the latest properties
  [listingProperties release];
  listingProperties = [properties retain];
  
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  
  if ([scope isEqualToString:ServiceResourceScope]) {
    [self performSelectorOnMainThread:@selector(preUpdateWithPropertiesActionsForServices:) 
                           withObject:properties
                        waitUntilDone:NO];
    
    [serviceProperties release];
    serviceProperties = [[BioCatalogueClient documentAtPath:[resourceURL path]] retain];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[BioCatalogueClient documentAtPath:[userURL path]] retain];
    
    [self performSelectorOnMainThread:@selector(postUpdateWithPropertiesActionsForServices)
                           withObject:nil
                        waitUntilDone:NO];
  } else if ([scope isEqualToString:UserResourceScope]) {
    [userProperties release];
    userProperties = [properties retain];
    
    [uiContentController updateUserUIElementsWithProperties:properties];
  } else {
    [providerProperties release];
    providerProperties = [properties retain];
    
    [uiContentController updateProviderUIElementsWithProperties:properties];
  }
  
  [self stopLoadingAnimation];
  controllerIsCurrentlyBusy = NO;
  
  [self touchToolbar:mainToolbar];
} // updateWithProperties:scope

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties {    
  scopeOfResourceBeingViewed = ServiceResourceScope;

  [favouriteServiceBarButtonItem setEnabled:[BioCatalogueClient userIsAuthenticated]];
  [self updateWithProperties:properties withScope:ServiceResourceScope];
  
  if (ignoreSerializingOnThisOccasion) {
    ignoreSerializingOnThisOccasion = NO;
  } else {
    [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:properties withScope:ServiceResourceScope];
  }
} // updateWithPropertiesForServicesScope

-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties {
  scopeOfResourceBeingViewed = UserResourceScope;
  
  [favouriteServiceBarButtonItem setEnabled:NO];
  [self updateWithProperties:properties withScope:UserResourceScope];  
  [self setContentView:userDetailView forParentView:mainContentView];
} // updateWithPropertiesForUsersScope

-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties {
  scopeOfResourceBeingViewed = ProviderResourceScope;
  
  [favouriteServiceBarButtonItem setEnabled:NO];
  [self updateWithProperties:properties withScope:ProviderResourceScope];  
  [self setContentView:providerDetailView forParentView:mainContentView];
} // updateWithPropertiesForProvidersScope

-(void) updateWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {
  scopeOfResourceBeingViewed = AnnouncementResourceScope;
  lastAnnouncementID = announcementID;
  
  [favouriteServiceBarButtonItem setEnabled:NO];
  
  [self setContentView:announcementDetailView forParentView:mainContentView];
  [uiContentController updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:announcementID];
  
  [self touchToolbar:mainToolbar];

  [self stopLoadingAnimation];
  
  if (ignoreSerializingOnThisOccasion) {
    ignoreSerializingOnThisOccasion = NO;
  } else {
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:announcementID] forKey:JSONIDElement];
    [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:properties withScope:AnnouncementResourceScope];
  }
} // updateWithPropertiesForAnnouncementWithID


#pragma mark -
#pragma mark IBActions

-(void) markUnmarkServiceAsFavourite:(id)sender {
  // TODO: implement
/*  
  [self touchToolbar:mainToolbar];
  if (![BioCatalogueClient userIsAuthenticated]) return;
  
  NSUInteger uniqueID = [[[serviceProperties objectForKey:JSONSelfElement] lastPathComponent] intValue];
  Service *service = [BioCatalogueResourceManager serviceWithUniqueID:uniqueID];
  
  if ([BioCatalogueResourceManager serviceWithUniqueIDIsFavourited:uniqueID]) {
    [@"remove from favourites" log];
  } else {
    [@"add to favourites" log];
  }
  
//  [BioCatalogueResourceManager commitChanges];
  [self updateMarkAsFavouriteToolbarItemForServiceWithUniqueID:uniqueID];
*/
} // markUnmarkServiceAsFavourite

-(void) showProviderInfo:(id)sender {
  NSDictionary *currentListingProperties = [listingProperties retain];
  NSDictionary *currentProviderProperties = [providerProperties retain];
  
  NSDictionary *provider = [[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                            objectForKey:JSONProviderElement];
  [self updateWithProperties:provider withScope:ProviderResourceScope];
  
  [self loadViewIntoContextualPopover:providerIDCard 
                             intoView:serviceDetailView
                   withViewController:nil
                    withArrowFromRect:[sender frame] 
                             withSize:[providerIDCard frame].size];
  
  [listingProperties release];
  listingProperties = currentListingProperties;
  
  [providerProperties release];
  providerProperties = currentProviderProperties;
} // showProviderInfo

-(void) showSubmitterInfo:(id)sender {
  NSDictionary *currentListingProperties = [listingProperties retain];
  NSDictionary *currentUserProperties = [userProperties retain];
  
  [self updateWithProperties:userProperties withScope:UserResourceScope];
  
  [self loadViewIntoContextualPopover:userIDCard 
                             intoView:serviceDetailView
                   withViewController:nil
                    withArrowFromRect:[sender frame]
                             withSize:[userIDCard frame].size];
  
  [listingProperties release];
  listingProperties = currentListingProperties;
  
  [userProperties release];
  userProperties = currentUserProperties;
}

-(void) showMonitoringStatusInfo:(id)sender {
  if (monitoringStatusInformationAvailable) {
    dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
      NSString *serviceID = [[listingProperties objectForKey:JSONResourceElement] lastPathComponent];
      [monitoringStatusViewController updateWithMonitoringStatusInfoForServiceWithID:[serviceID intValue]];
    });
    
    [self loadViewIntoContextualPopover:nil 
                               intoView:serviceDetailView
                     withViewController:monitoringStatusViewController
                      withArrowFromRect:[sender frame]
                               withSize:CGSizeMake(320, 250)];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring" 
                                                    message:@"No monitoring information is available for this service." 
                                                   delegate:self
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }  
}

-(void) showServiceComponents:(id)sender {
  NSURL *variantURL = [NSURL URLWithString:[[[serviceProperties objectForKey:JSONVariantsElement] lastObject] objectForKey:JSONResourceElement]];
  NSString *path;
  if ([listingProperties serviceListingIsRESTService]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
  } else if ([listingProperties serviceListingIsSOAPService]) { // this takes into account soaplab
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
  } else {
    path = nil;
  }

  if (path == nil) return;
  
  if (![serviceComponentsViewController view]) [serviceComponentsViewController loadView];
  dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
    [serviceComponentsViewController updateWithServiceComponentsForPath:path];
  });

  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:serviceComponentsViewController];
  [self loadViewIntoContextualPopover:nil 
                             intoView:serviceDetailView
                   withViewController:navController
                    withArrowFromRect:[sender frame]
                             withSize:CGSizeMake(320, 460)];
}

-(void) dismissAuxiliaryDetailPanel:(id)sender {
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
  [gestureHandler disableInteractionDisablingLayer:[recognizer autorelease]];
} // dismissAuxiliaryDetailPanel

-(void) exposeAuxiliaryDetailPanel:(id)sender {
  [defaultPopoverController dismissPopoverAnimated:YES];
  
  UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
  [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [gestureHandler rolloutAuxiliaryDetailPanel:[recognizer autorelease]];
} // exposeAuxiliaryDetailPanel

-(IBAction) showResourceInPullOutBrowser:(NSURL *)url {
  if ([webBrowser isLoading]) [webBrowser stopLoading];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:APIRequestTimeout];
  [webBrowser loadRequest:request];
  
  if (contextualPopoverController && [contextualPopoverController isPopoverVisible]) {
    [contextualPopoverController dismissPopoverAnimated:YES];
  }
  
  [self setContentView:webBrowser forParentView:auxiliaryDetailPanel];
} // showResourceInBioCatalogue

-(IBAction) showActionSheetForCurrentPullOutBrowserContent:(id)sender {
  if (actionSheetForPullOutView) [actionSheetForPullOutView release];
  
  actionSheetForPullOutView = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Open in Safari", @"Mail this page to...", nil];
  [actionSheetForPullOutView showFromBarButtonItem:sender animated:YES];
} // showActionSheetForCurrentPullOutBrowserContent

-(void) onSVWebViewControllerDismissal:(UIWebView *)webView {
  if ([[[webView request] URL] isEqual:[[webBrowser request] URL]]) return;
  
  if ([webBrowser isLoading]) [webBrowser stopLoading];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[[webView request] URL]
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:APIRequestTimeout];
  [webBrowser loadRequest:request];
  
  [self setContentView:webBrowser forParentView:auxiliaryDetailPanel];
}

-(IBAction) showCurrentPullOutBrowserContentInFullScreen:(id)sender {
  SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[[[webBrowser request] URL] absoluteString]];
  [webViewController onDismissPerformSelector:@selector(onSVWebViewControllerDismissal:) onTarget:self];
  
  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  [[appDelegate tabBarController] presentModalViewController:webViewController animated:YES];
  
  [webViewController release];  
} // showCurrentPullOutBrowserContentInFullScreen

-(IBAction) showCurrentResourceInBioCatalogue:(id)sender {
  [self showResourceInPullOutBrowser:[self URLOfResourceBeingViewed]];
} // showCurrentResourceInBioCatalogue

-(IBAction) showCurrentResourceInSafari:(id)sender {
  [[UIApplication sharedApplication] openURL:[self URLOfResourceBeingViewed]];
} // showCurrentResourceInSafari

-(IBAction) showActionSheetForCurrentResource:(id)sender {
  NSString *resource = [scopeOfResourceBeingViewed printableResourceScope];
  resource = (resource ? [@" " stringByAppendingString:resource] : @"");
  NSString *mailThis = [NSString stringWithFormat:@"Mail this%@ to...", [resource lowercaseString]];
  
  if (actionSheetForMainView) [actionSheetForMainView release];
  actionSheetForMainView = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:nil
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Open in BioCatalogue", @"Open in Safari", mailThis, nil];
  [actionSheetForMainView showFromBarButtonItem:sender animated:YES];
} // showActionSheetForCurrentResource

-(IBAction) composeMailMessageToUser:(id)sender {
  NSString *publicEmail = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONPublicEmailElement]];

  if ([publicEmail isValidJSONValue]) {
    NSURL *address = [NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", publicEmail]];
    [uiContentController composeMailMessage:address];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to compose mail"
                                                    message:@"This user does not have a public e-mail address." 
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
} // composeMailMessage

#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc {
  
  [barButtonItem setTitle:@"Main Menu"];
  
  NSMutableArray *items = [[mainToolbar items] mutableCopy];
  
  [items insertObject:barButtonItem atIndex:0];
  [mainToolbar setItems:items animated:YES];
  
  [items release];
  
  defaultPopoverController = pc;
  
  if (contextualPopoverController) [contextualPopoverController dismissPopoverAnimated:YES];
} // splitViewController:willHideViewController:withBarButtonItem:forPopoverController

- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  NSMutableArray *items = [[mainToolbar items] mutableCopy];
  if ([items objectAtIndex:0] != spaceAfterMainMenu) [items removeObjectAtIndex:0]; 
  [mainToolbar setItems:items animated:YES];  
  [items release];
  
  defaultPopoverController = nil;

  if (contextualPopoverController) [contextualPopoverController dismissPopoverAnimated:YES];
} // splitViewController:willShowViewController:invalidatingBarButtonItem


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSString *message, *subject, *resource;
  
  if (actionSheet == actionSheetForMainView) {
    switch (buttonIndex) {
      case OpenInSafari: 
        return [self showCurrentResourceInSafari:self];
      case OpenInBioCatalogue: 
        return [self showCurrentResourceInBioCatalogue:self];
      case MailThis:
        resource = [scopeOfResourceBeingViewed printableResourceScope];
        resource = (resource ? [@" " stringByAppendingString:resource] : @"");
        message = [NSString generateInterestedInMessage:resource withURL:[self URLOfResourceBeingViewed]];
        
        subject = [NSString stringWithFormat:@"BioCatalogue%@: %@", resource, [self nameOfResourceBeingViewed]];
        [uiContentController composeMailMessage:nil subject:subject content:message];
        return;
    }    
  } else if (actionSheet == actionSheetForPullOutView) {
    switch (buttonIndex) {
      case PullOutOpenInSafari: 
        [[UIApplication sharedApplication] openURL:[[webBrowser request] URL]]; 
        return;
      case PullOutMailThis:
        message = [NSString generateInterestedInMessage:@" page" withURL:[[webBrowser request] URL]];        
        [uiContentController composeMailMessage:nil subject:@"BioCatalogue: Check this out..." content:message];
        return;
    }    
  }
} // actionSheet:clickedButtonAtIndex


#pragma mark -
#pragma mark UIPopoverControllerDelegate

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  UIView *myView = [[popoverController contentViewController] view];
  
  if (myView == userIDCard) {
    [userIDCardContainer addSubview:userIDCard];
  }
  
  if (myView == providerIDCard) {
    [providerIDCardContainer addSubview:providerIDCard];
  }
} // popoverControllerDidDismissPopover


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [favouriteServiceBarButtonItem setEnabled:NO];
  [self touchToolbar:mainToolbar];
  
  if (!viewHasAlreadyInitialized) {
    NSDictionary *properties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LastViewedResourceKey];
    NSString *scope = [[NSUserDefaults standardUserDefaults] stringForKey:LastViewedResourceScopeKey];

    if ([scope isEqualToString:ServiceResourceScope]) {
      ignoreSerializingOnThisOccasion = YES;
      dispatch_async(dispatch_queue_create("Load last viewed resource", NULL), ^{
        [self updateWithPropertiesForServicesScope:properties];
      });
    } else if ([scope isEqualToString:UserResourceScope]) {
      [self updateWithPropertiesForUsersScope:properties];
    } else if ([scope isEqualToString:ProviderResourceScope]) {
      [self updateWithPropertiesForProvidersScope:properties];
    } else if ([scope isEqualToString:AnnouncementResourceScope]) {
      ignoreSerializingOnThisOccasion = YES;
      [self updateWithPropertiesForAnnouncementWithID:[[properties valueForKey:JSONIDElement] integerValue]];
    } else {
      [self setContentView:defaultView forParentView:mainContentView];
      [self stopLoadingAnimation];
    }

    UIGestureRecognizer *recognizer;
        
    // pan recognizer for userDetailIDCardView
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                         action:@selector(panViewButResetPositionAfterwards:)];
    [userIDCardContainer addGestureRecognizer:recognizer];
    [recognizer release];
    
    
    // right swipe recognizer for auxiliaryDetailPanel
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                           action:@selector(rolloutAuxiliaryDetailPanel:)];
    [auxiliaryDetailPanel addGestureRecognizer:recognizer];
    [recognizer release];
    
    // left swipe recognizer for auxiliaryDetailPanel
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                           action:@selector(rolloutAuxiliaryDetailPanel:)];
    [((UISwipeGestureRecognizer *)recognizer) setDirection:UISwipeGestureRecognizerDirectionLeft];
    [auxiliaryDetailPanel addGestureRecognizer:recognizer];    
    [recognizer release];
    
    // tap recognizer for interactionDisablingLayer
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                         action:@selector(disableInteractionDisablingLayer:)];
    [interactionDisablingLayer addGestureRecognizer:recognizer];
    [recognizer release];
    
    [gestureHandler disableInteractionDisablingLayer:nil];
        
    viewHasAlreadyInitialized = YES;
  }
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  // default view outlets
  [mainToolbar release];
  [defaultView release];  
  [activityIndicator release];
  [mainContentView release];
  [webBrowser release];
  [webBrowserToolbar release];
  
  [favouriteServiceBarButtonItem release];
  [viewCurrentResourceBarButtonItem release];
  [spaceAfterMainMenu release];
  
  [auxiliaryDetailPanel release];
  [interactionDisablingLayer release];
  
  // service view outlets
  [serviceDetailView release];
  [serviceComponentsViewController release];
  [serviceName release];
  
  // user view outlets  
  [userDetailView release];
  [userIDCard release];
  [userIDCardContainer release];
  
  // provider view outlets
  [providerDetailView release];
  [providerIDCard release];
  [providerIDCardContainer release];
  
  // other outlets
  [gestureHandler release];
  [monitoringStatusViewController release];
  [webBrowserController release];
  
  [announcementDetailView release];
  
  [uiContentController release];
} // releaseIBOutlets

- (void)viewDidUnload {
  [defaultPopoverController release];
  [contextualPopoverController release];
  [actionSheetForPullOutView release];
  
  [actionSheetForMainView release];

	[super viewDidUnload];
} // viewDidUnload

- (void)dealloc {
  [defaultPopoverController release];
  [contextualPopoverController release];
  
  [actionSheetForMainView release];
  [actionSheetForPullOutView release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
