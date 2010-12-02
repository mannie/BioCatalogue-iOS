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

@synthesize monitoringStatusViewController, serviceComponentsViewController;


#pragma mark -
#pragma mark Helpers

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
  [UIView startLoadingAnimation:activityIndicator dimmingView:serviceNameLabel];
} // startLoadingAnimation

-(void) stopLoadingAnimation {
  [UIView stopLoadingAnimation:activityIndicator undimmingView:serviceNameLabel];
} // stopLoadingAnimation

-(void) setContentView:(UIView *)subView forParentView:(UIView *)parentView {  
  // remove subviews
  for (id item in parentView.subviews) {
    if (![item isMemberOfClass:[UIToolbar class]] && ![item isMemberOfClass:[UIActivityIndicatorView class]]) {
      [item removeFromSuperview];
    }
  } // for each item in subview
  
  [parentView addSubview:subView];
  
  defaultView.hidden = subView != defaultView;
  
  // set up web browser
  if (parentView == auxiliaryDetailPanel) {
    auxiliaryToolbar.hidden = subView == webBrowser;
    webBrowserToolbar.hidden = !auxiliaryToolbar.hidden;
    webBrowser.hidden = webBrowserToolbar.hidden;
    
    [self exposeAuxiliaryDetailPanel:self];
  }
  
  [parentView setNeedsLayout];
} // setContentView:forParentView

#pragma mark -
#pragma mark Managing loading resources into the view

-(void) setDescription:(NSString *)description {
  NSString *value = [NSString stringWithFormat:@"%@", description];
  serviceDescriptionLabel.text = ([value isValidJSONValue] ? value : NoDescriptionText);
} // setDescription

-(void) updateWithProperties:(NSDictionary *)properties withScope:(NSString *)scope {
  // TODO: put a check to see whether a fetch is already occuring or not
  
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
    monitoringStatusInformationAvailable = [lastChecked isValidJSONValue];
    NSURL *imageURL = [NSURL URLWithString:
                       [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
    monitoringStatusIcon.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
    
    // submitter details
    [userProperties release];
    NSURL *userURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
    userProperties = [[[JSON_Helper helper] documentAtPath:[userURL path]] copy];
    
    serviceSubmitterNameLabel.text = [userProperties objectForKey:JSONNameElement];
    
    // service components
    BioCatalogueClient *client = [BioCatalogueClient client];
    BOOL isREST = [client serviceIsREST:properties];
    BOOL isSOAP = [client serviceIsSOAP:properties];
    
    if (isREST) {
      componentsLabel.text = RESTComponentsText;
    } else if (isSOAP) {
      componentsLabel.text = SOAPComponentsText;
    } else {
      componentsLabel.text = [client serviceType:properties];
    }
    
    showComponentsButton.hidden = !isREST && !isSOAP;    
  } else if ([scope isEqualToString:UsersSearchScope]) {
    [userProperties release];
    userProperties = [properties copy];
    
    userNameLabel.text = [userProperties objectForKey:JSONNameElement];
    
    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
    userAffiliationLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
    
    detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCountryElement]];
    userCountryLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
    
    detailItem = [NSString stringWithFormat:@"%@", [[userProperties objectForKey:JSONLocationElement] objectForKey:JSONCityElement]];
    userCityLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
    
    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONPublicEmailElement]];
    userEmailLabel.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
    
    detailItem = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONJoinedElement]];
    userJoinedLabel.text = detailItem;
    if ([detailItem length] > 10) {
      userJoinedLabel.text = [detailItem stringByReplacingCharactersInRange:NSMakeRange(10, 10) withString:@""];
    }
  } else {
    [providerProperties release];
    providerProperties = [properties copy];
    
    providerNameLabel.text = [providerProperties objectForKey:JSONNameElement];
    
    detailItem = [NSString stringWithFormat:@"%@", [providerProperties objectForKey:JSONDescriptionElement]];
    providerDescriptionLabel.text = ([detailItem isValidJSONValue] ? detailItem : NoInformationText);
  }
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:properties withScope:scope];
  
  [self stopLoadingAnimation];
} // updateWithProperties:scope

-(void) updateWithPropertiesForServicesScope:(NSDictionary *)properties {    
  [self updateWithProperties:properties withScope:ServicesSearchScope];
  [self setContentView:serviceDetailView forParentView:mainContentView];
  scopeOfResourceBeingViewed = ServicesSearchScope;
} // updateWithPropertiesForServicesScope

-(void) updateWithPropertiesForUsersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:UsersSearchScope];  
  [self setContentView:userDetailView forParentView:mainContentView];
  scopeOfResourceBeingViewed = UsersSearchScope;
} // updateWithPropertiesForUsersScope

-(void) updateWithPropertiesForProvidersScope:(NSDictionary *)properties {
  [self updateWithProperties:properties withScope:ProvidersSearchScope];  
  [self setContentView:providerDetailView forParentView:mainContentView];
  scopeOfResourceBeingViewed = ProvidersSearchScope;
} // updateWithPropertiesForProvidersScope


#pragma mark -
#pragma mark IBActions

-(void) showProviderInfo:(id)sender {
  NSDictionary *currentListingProperties = [listingProperties copy];
  NSDictionary *currentProviderProperties = [providerProperties copy];
  
  NSDictionary *provider = [[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                            objectForKey:JSONProviderElement];
  [self updateWithProperties:provider withScope:ProvidersSearchScope];
  
  [self loadViewIntoContextualPopover:providerIDCard 
                             intoView:serviceDetailView
                   withViewController:nil
                    withArrowFromRect:[sender frame] 
                             withSize:providerIDCard.frame.size];
  
  listingProperties = currentListingProperties;
  providerProperties = currentProviderProperties;
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:listingProperties withScope:ServicesSearchScope];
} // showProviderInfo

-(void) showSubmitterInfo:(id)sender {
  NSDictionary *currentListingProperties = [listingProperties copy];
  NSDictionary *currentUserProperties = [userProperties copy];
  
  [self updateWithProperties:userProperties withScope:UsersSearchScope];
  
  [self loadViewIntoContextualPopover:userIDCard 
                             intoView:serviceDetailView
                   withViewController:nil
                    withArrowFromRect:[sender frame]
                             withSize:userIDCard.frame.size];
  
  listingProperties = currentListingProperties;
  userProperties = currentUserProperties;
  
  [[NSUserDefaults standardUserDefaults] serializeLastViewedResource:listingProperties withScope:ServicesSearchScope];
}

-(void) showMonitoringStatusInfo:(id)sender {
  if (monitoringStatusInformationAvailable) {
    [self startLoadingAnimation];
    
    NSURL *serviceURL = [NSURL URLWithString:[listingProperties objectForKey:JSONResourceElement]];
    NSString *path = [[serviceURL path] stringByAppendingPathComponent:@"monitoring"];
    
    [NSOperationQueue addToNewQueueSelector:@selector(fetchMonitoringStatusInfo:)
                                   toTarget:monitoringStatusViewController
                                 withObject:path];
    
    [self loadViewIntoContextualPopover:nil 
                               intoView:serviceDetailView
                     withViewController:monitoringStatusViewController
                      withArrowFromRect:[sender frame]
                               withSize:CGSizeMake(460, 230)];
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
  [self startLoadingAnimation];
  
  NSURL *variantURL = [NSURL URLWithString:[[[serviceProperties objectForKey:JSONVariantsElement] lastObject] 
                                            objectForKey:JSONResourceElement]];
  NSString *path;
  if ([[BioCatalogueClient client] serviceIsREST:listingProperties]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
  } else {
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
  }
  
  [NSOperationQueue addToNewQueueSelector:@selector(fetchServiceComponents:) 
                                 toTarget:serviceComponentsViewController 
                               withObject:path];
  
  [self loadViewIntoContextualPopover:nil 
                             intoView:serviceDetailView
                   withViewController:serviceComponentsViewController
                    withArrowFromRect:[sender frame]
                             withSize:CGSizeMake(500, 460)];
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
  
  favouriteServiceBarButtonItem.enabled = [scopeOfResourceBeingViewed isEqualToString:ServicesSearchScope];
  
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (!viewHasAlreadyInitialized) {
    NSDictionary *properties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:LastViewedResourceKey];
    NSString *scope = [[NSUserDefaults standardUserDefaults] stringForKey:LastViewedResourceScopeKey];
    
    if ([scope isEqualToString:ServicesSearchScope]) {
      [NSOperationQueue addToCurrentQueueSelector:@selector(setDescription:) 
                                         toTarget:self 
                                       withObject:[properties objectForKey:JSONDescriptionElement]];
      [NSOperationQueue addToMainQueueSelector:@selector(updateWithPropertiesForServicesScope:) 
                                      toTarget:self
                                    withObject:properties];
    } else if ([scope isEqualToString:UsersSearchScope]) {
      [self updateWithPropertiesForUsersScope:properties];
    } else if ([scope isEqualToString:ProvidersSearchScope]) {
      [self setDescription:[properties objectForKey:JSONDescriptionElement]];
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
//    [NSOperationQueue addToCurrentQueueSelector:@selector(webBrowserActivityWatcher) toTarget:self withObject:nil];
    
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
  
  [serviceNameLabel release];
  [serviceDescriptionLabel release];
  [serviceProviderNameLabel release];
  [serviceSubmitterNameLabel release];
  
  [componentsLabel release];
  [showComponentsButton release];
  [serviceComponentsViewController release];
  
  // user view outlets  
  [userDetailView release];
  [userIDCard release];
  [userIDCardContainer release];
  
  [userNameLabel release];
  [userAffiliationLabel release];
  [userCountryLabel release];
  [userCityLabel release];
  [userEmailLabel release];
  [userJoinedLabel release];
  
  
  // provider view outlets
  [providerDetailView release];
  [providerIDCard release];
  [providerIDCardContainer release];
  
  [providerNameLabel release];
  [providerDescriptionLabel release];
  
  // other outlets
  [gestureHandler release];
  [monitoringStatusViewController release];
  [monitoringStatusIcon release];
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
