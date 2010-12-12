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


@synthesize monitoringStatusViewController, serviceComponentsViewController, webBrowserController;


#pragma mark -
#pragma mark Helpers

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
    viewController.view = myView;
  }
  
  [contextualPopoverController release];
  contextualPopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
  contextualPopoverController.delegate = self;
  [contextualPopoverController setPopoverContentSize:size animated:YES];
  [contextualPopoverController presentPopoverFromRect:rect
                                               inView:parentView
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
} // loadViewIntoContextualPopover:intoView:withViewController:withArrowFromRect:withSize

-(void) webBrowserActivityWatcher {
  // FIXME: change this so that it actually stops and starts the activity update
  // IBOutlet webBrowserActivityIndicator is currently disconnected
  while (YES) {
    [NSThread sleepForTimeInterval:1];
    
    if (webBrowser.loading) {
      [webBrowserActivityIndicator startAnimating];
    } else {
      [webBrowserActivityIndicator stopAnimating];
    }
  }
} // webActivityWatcher

-(void) startLoadingAnimation {
  [activityIndicator startAnimating];
  [UIView animateWithDuration:0.5
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{ serviceName.alpha = 0.1; }
                   completion:nil];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [activityIndicator stopAnimating];
  [UIView animateWithDuration:0.5
                        delay:0
                      options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^{ serviceName.alpha = 1; }
                   completion:nil];
} // stopLoadingAnimation

-(void) setContentView:(UIView *)subView forParentView:(UIView *)parentView {  
  defaultView.hidden = subView != defaultView;
  
  // auxiliary panel
  if (parentView == auxiliaryDetailPanel && currentAuxiliaryPanelView != subView) {
    [currentAuxiliaryPanelView removeFromSuperview];
    [parentView addSubview:subView];
    currentAuxiliaryPanelView = subView;
    
    webBrowserToolbar.hidden = subView != webBrowser;
    webBrowser.hidden = webBrowserToolbar.hidden;
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

-(void) preUpdateWithPropertiesActionsForServices:(NSDictionary *)properties {
  [uiContentController updateServiceUIElementsWithProperties:properties
                                                providerName:nil 
                                               submitterName:nil
                                             showLoadingText:YES];
  
  // monitoring details
  NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                           [[properties objectForKey:JSONLatestMonitoringStatusElement] 
                            objectForKey:JSONLastCheckedElement]];
  monitoringStatusInformationAvailable = [lastChecked isValidJSONValue];
  
  [self.view setNeedsDisplay];  
} // preUpdateWithPropertiesActionsForServices

-(void) postUpdateWithPropertiesActionsForServices {
  NSString *provider = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                         objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
  
  [uiContentController updateServiceUIElementsWithProperties:nil
                                                providerName:provider
                                               submitterName:[userProperties objectForKey:JSONNameElement]
                                             showLoadingText:NO];
  
  [self setContentView:serviceDetailView forParentView:mainContentView];
  
  [self.view setNeedsDisplay];  
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
    serviceProperties = [[WebAccessController documentAtPath:[resourceURL path]] retain];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[WebAccessController documentAtPath:[userURL path]] retain];
    
    [self performSelectorOnMainThread:@selector(postUpdateWithPropertiesActionsForServices)
                           withObject:nil
                        waitUntilDone:NO];
  } else if ([scope isEqualToString:UserResourceScope]) {
    [userProperties release];
    userProperties = [properties retain];
    
    [uiContentController updateUserProviderUIElementsWithProperties:properties];
  } else {
    [providerProperties release];
    providerProperties = [properties retain];
    
    [uiContentController updateProviderUIElementsWithProperties:properties];
  }
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:properties withScope:scope];
  
  [self stopLoadingAnimation];
  controllerIsCurrentlyBusy = NO;
} // updateWithProperties:scope

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties {    
  [self updateWithProperties:properties withScope:ServiceResourceScope];
  scopeOfResourceBeingViewed = ServiceResourceScope;
} // updateWithPropertiesForServicesScope

-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:UserResourceScope];  
  [self setContentView:userDetailView forParentView:mainContentView];
  scopeOfResourceBeingViewed = UserResourceScope;
} // updateWithPropertiesForUsersScope

-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:ProviderResourceScope];  
  [self setContentView:providerDetailView forParentView:mainContentView];
  scopeOfResourceBeingViewed = ProviderResourceScope;
} // updateWithPropertiesForProvidersScope


#pragma mark -
#pragma mark IBActions

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
                             withSize:providerIDCard.frame.size];
  
  [listingProperties release];
  listingProperties = currentListingProperties;
  
  [providerProperties release];
  providerProperties = currentProviderProperties;
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:listingProperties withScope:ServiceResourceScope];
} // showProviderInfo

-(void) showSubmitterInfo:(id)sender {
  NSDictionary *currentListingProperties = [listingProperties retain];
  NSDictionary *currentUserProperties = [userProperties retain];
  
  [self updateWithProperties:userProperties withScope:UserResourceScope];
  
  [self loadViewIntoContextualPopover:userIDCard 
                             intoView:serviceDetailView
                   withViewController:nil
                    withArrowFromRect:[sender frame]
                             withSize:userIDCard.frame.size];
  
  [listingProperties release];
  listingProperties = currentListingProperties;
  
  [userProperties release];
  userProperties = currentUserProperties;
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:listingProperties withScope:ServiceResourceScope];
}

-(void) showMonitoringStatusInfo:(id)sender {
  if (monitoringStatusInformationAvailable) {
    NSURL *serviceURL = [NSURL URLWithString:[listingProperties objectForKey:JSONResourceElement]];
    NSString *path = [[serviceURL path] stringByAppendingPathComponent:@"monitoring"];

    dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
      [monitoringStatusViewController fetchMonitoringStatusInfo:path];
    });
        
    [self loadViewIntoContextualPopover:nil 
                               intoView:serviceDetailView
                     withViewController:monitoringStatusViewController
                      withArrowFromRect:[sender frame]
                               withSize:CGSizeMake(400, 220)];
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
  NSURL *variantURL = [NSURL URLWithString:[[[serviceProperties objectForKey:JSONVariantsElement] lastObject] 
                                            objectForKey:JSONResourceElement]];
  NSString *path;
  if ([BioCatalogueClient serviceIsREST:listingProperties]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
  } else {
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
  }
  
  dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
    [serviceComponentsViewController fetchServiceComponents:path];
  });

  [self loadViewIntoContextualPopover:nil 
                             intoView:serviceDetailView
                   withViewController:serviceComponentsViewController
                    withArrowFromRect:[sender frame]
                             withSize:CGSizeMake(500, 440)];
}

-(void) dismissAuxiliaryDetailPanel:(id)sender {
  UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
  [gestureHandler disableInteractionDisablingLayer:[recognizer autorelease]];
} // dismissAuxiliaryDetailPanel

-(void) exposeAuxiliaryDetailPanel:(id)sender {
  UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
  recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
  [gestureHandler rolloutAuxiliaryDetailPanel:[recognizer autorelease]];
} // exposeAuxiliaryDetailPanel

-(void) showCurrentResourceInBioCatalogue:(id)sender {  
  NSURL *url = [NSURL URLWithString:[listingProperties objectForKey:JSONResourceElement]];
  [self showResourceInBioCatalogue:url];
} // showCurrentResourceInBioCatalogue

-(void) showResourceInBioCatalogue:(NSURL *)url {
  NSURLRequest *request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:10];
  [webBrowser loadRequest:request];
  
  if (contextualPopoverController && [contextualPopoverController isPopoverVisible]) {
    [contextualPopoverController dismissPopoverAnimated:YES];
  }
  
  [self setContentView:webBrowser forParentView:auxiliaryDetailPanel];  
} // showResourceInBioCatalogue


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc 
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem 
       forPopoverController: (UIPopoverController*)pc {
  
  barButtonItem.title = @"Main Menu";
  
  NSMutableArray *items = [[mainToolbar items] mutableCopy];
  
  favouriteServiceBarButtonItem.enabled = [scopeOfResourceBeingViewed isEqualToString:ServiceResourceScope];
  
  [items insertObject:barButtonItem atIndex:0];
  [mainToolbar setItems:items animated:YES];
  
  [items release];
  
  defaultPopoverController = pc;
} // splitViewController:willHideViewController:withBarButtonItem:forPopoverController

- (void)splitViewController: (UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
  
  NSMutableArray *items = [[mainToolbar items] mutableCopy];
  [items removeObjectAtIndex:0]; 
  [mainToolbar setItems:items animated:YES];  
  [items release];
  
  defaultPopoverController = nil;
} // splitViewController:willShowViewController:invalidatingBarButtonItem


#pragma mark -
#pragma mark UIPopoverControllerDelegate

-(void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  UIView *myView = popoverController.contentViewController.view;
  
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
  
  if (!viewHasAlreadyInitialized) {
    NSDictionary *properties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LastViewedResourceKey];
    NSString *scope = [[NSUserDefaults standardUserDefaults] stringForKey:LastViewedResourceScopeKey];
    
    if ([scope isEqualToString:ServiceResourceScope]) {
      dispatch_async(dispatch_queue_create("Load last viewed resource", NULL), ^{
        [self updateWithPropertiesForServicesScope:properties];
      });
    } else if ([scope isEqualToString:UserResourceScope]) {
      [self updateWithPropertiesForUsersScope:properties];
    } else if ([scope isEqualToString:ProviderResourceScope]) {
      [self updateWithPropertiesForProvidersScope:properties];
    } else {
      [self setContentView:defaultView forParentView:mainContentView];
    }
    
    UIGestureRecognizer *recognizer;
    
    // pan recognizer for providerDetailIDCardView
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                         action:@selector(panViewButResetPositionAfterwards:)];
    [providerIDCardContainer addGestureRecognizer:recognizer];
    [recognizer release];
    
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
    ((UISwipeGestureRecognizer *)recognizer).direction = UISwipeGestureRecognizerDirectionLeft;
    [auxiliaryDetailPanel addGestureRecognizer:recognizer];    
    [recognizer release];
    
    // tap recognizer for interactionDisablingLayer
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:gestureHandler 
                                                         action:@selector(disableInteractionDisablingLayer:)];
    [interactionDisablingLayer addGestureRecognizer:recognizer];
    [recognizer release];
    
    [gestureHandler disableInteractionDisablingLayer:nil];
    
    //    FIXME: enable web browser activity watcher
    [NSThread detachNewThreadSelector:@selector(webBrowserActivityWatcher) toTarget:self withObject:nil];
    
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
  [webBrowserActivityIndicator release];
  
  [favouriteServiceBarButtonItem release];
  [viewResourceInBioCatalogueBarButtonItem release];
  
  [auxiliaryToolbar release];
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
  
  [uiContentController release];
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
  
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end
