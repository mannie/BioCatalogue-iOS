//
//  ServiceDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/10/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation ServiceDetailViewController_iPhone

@synthesize userDetailViewController, providerDetailViewController, monitoringStatusViewController, serviceComponentsViewController;


typedef enum { MailThis, Cancel } ActionSheetIndex; // ordered UPWARDS on display

#pragma mark -
#pragma mark Helpers

-(void) preFetchActions:(NSDictionary *)properties {
  [uiContentController updateServiceUIElementsWithProperties:properties
                                                providerName:nil 
                                               submitterName:nil
                                             showLoadingText:YES];
  
  // monitoring details
  NSString *lastChecked = [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement];
  monitoringStatusInformationAvailable = [[NSString stringWithFormat:@"%@", lastChecked] isValidJSONValue];
  
  int serviceID = [[[properties objectForKey:JSONResourceElement] lastPathComponent] intValue];
  if ([BioCatalogueResourceManager serviceWithUniqueIDIsBeingMonitored:serviceID]) {
    Service *service = [BioCatalogueResourceManager serviceWithUniqueID:serviceID];
    
    if ([[service hasUpdate] boolValue]) {
      [service setHasUpdate:[NSNumber numberWithBool:NO]];
      [BioCatalogueResourceManager commitChanges];
      
      [UpdateCenter performSelectorOnMainThread:@selector(updateApplicationBadgesForServiceUpdates) withObject:nil waitUntilDone:NO];
    }
  }  
} // preFetchActions

-(void) postFetchActions {  
  NSString *provider = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                         objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
  
  [uiContentController updateServiceUIElementsWithProperties:nil
                                                providerName:provider
                                               submitterName:[submitterProperties objectForKey:JSONNameElement]
                                             showLoadingText:NO];
} // postFetchActions

-(void) updateWithProperties:(NSDictionary *)properties {
  [self performSelectorOnMainThread:@selector(preFetchActions:) withObject:properties waitUntilDone:NO];  

  [serviceListingProperties release];
  serviceListingProperties = [properties retain];  
  
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  serviceProperties = [[BioCatalogueClient documentAtPath:[resourceURL path]] retain];
  
  // submitter details
  NSURL *submitterURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
  submitterProperties = [[BioCatalogueClient documentAtPath:[submitterURL path]] retain];
  
  [self performSelectorOnMainThread:@selector(postFetchActions) withObject:nil waitUntilDone:NO];
} // updateWithProperties

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
  
  NSString *resource = [@" " stringByAppendingString:[ServiceResourceScope printableResourceScope]];
  
  NSURL *url = [NSURL URLWithString:[serviceListingProperties objectForKey:JSONResourceElement]];
  NSString *message = [NSString generateInterestedInMessage:resource withURL:url];
  
  NSString *subject = [NSString stringWithFormat:@"BioCatalogue%@: %@", resource, [serviceListingProperties objectForKey:JSONNameElement]];
  [uiContentController composeMailMessage:nil subject:subject content:message];  
}


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && serviceListingProperties) [self updateWithProperties:serviceListingProperties];
  
  UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
  [[self navigationItem] setRightBarButtonItem:item animated:YES];
  [item release];
  
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
#pragma mark IBActions

-(void) showProviderInfo:(id)sender {
  NSDictionary *properties = [[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] objectForKey:JSONProviderElement];
  
  if (![providerDetailViewController view]) [providerDetailViewController loadView];
  [providerDetailViewController updateWithProperties:properties];
  [providerDetailViewController showServicesButtonIfGreater:1];
  
  [[self navigationController] pushViewController:providerDetailViewController animated:YES];  
} // showProviderInfo

-(void) showSubmitterInfo:(id)sender {
  // submitting user
  if (![userDetailViewController view]) [userDetailViewController loadView];
  [userDetailViewController updateWithProperties:submitterProperties];
  
  [[self navigationController] pushViewController:userDetailViewController animated:YES];      
} // showSubmitterInfo

-(void) showMonitoringStatusInfo:(id)sender {
  if (monitoringStatusInformationAvailable) {
    if (![monitoringStatusViewController view]) [monitoringStatusViewController loadView];
    dispatch_async(dispatch_queue_create("Fetch monitoring statuses", NULL), ^{
      NSString *serviceID = [[serviceListingProperties objectForKey:JSONResourceElement] lastPathComponent];
      [monitoringStatusViewController updateWithMonitoringStatusInfoForServiceWithID:[serviceID intValue]];
    });
    
    [[self navigationController] pushViewController:monitoringStatusViewController animated:YES];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring" 
                                                    message:@"No monitoring information is available for this service." 
                                                   delegate:self
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }  
} // showMonitoringStatusInfo

-(void) showServiceComponents:(id)sender {
  NSURL *variantURL = [NSURL URLWithString:[[[serviceProperties objectForKey:JSONVariantsElement] lastObject] objectForKey:JSONResourceElement]];
  NSString *path;
  if ([serviceListingProperties serviceListingIsRESTService]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
  } else if ([serviceListingProperties serviceListingIsSOAPService]) { // this takes into account soaplab
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
  } else {
    path = nil;
  }
  
  [serviceComponentsViewController setTitle:nil];
  if (path == nil) return;
  
  if (![serviceComponentsViewController view]) [serviceComponentsViewController loadView];
  dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
    [serviceComponentsViewController updateWithServiceComponentsForPath:path];
  });
  
  [[self navigationController] pushViewController:serviceComponentsViewController animated:YES];
} // showServiceComponents

-(void) makeShowProvidersButtonVisible:(BOOL)visible {
  [providerButton setHidden:!visible];
} // makeShowProvidersButtonVisible


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [uiContentController release];
  [providerButton release];
  
  [userDetailViewController release];
  [providerDetailViewController release];  
  [monitoringStatusViewController release];
  [serviceComponentsViewController release];
  
  [myTableView release];
} // releaseIBOutlets

- (void)dealloc {
  [self releaseIBOutlets];
  
  [serviceListingProperties release];
  [serviceProperties release];
  [submitterProperties release];
  
  [super dealloc];
} // dealloc


@end

