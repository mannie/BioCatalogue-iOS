//
//  ServiceDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServiceDetailViewController_iPhone.h"


@implementation ServiceDetailViewController_iPhone

@synthesize userDetailViewController, providerDetailViewController, monitoringStatusViewController, serviceComponentsViewController;


#pragma mark -
#pragma mark Helpers

-(void) preFetchActions:(NSDictionary *)properties {
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
    
    if ([service.hasUpdate boolValue]) {
      service.hasUpdate = [NSNumber numberWithBool:NO];
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
  
  [self.view setNeedsDisplay];  
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


#pragma mark -
#pragma mark View lifecycle

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && serviceListingProperties) [self updateWithProperties:serviceListingProperties];
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
  NSDictionary *properties = [[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                              objectForKey:JSONProviderElement];
  
  [providerDetailViewController loadView];
  [providerDetailViewController updateWithProperties:properties];
  [providerDetailViewController makeShowServicesButtonVisible:NO];
  
  [self.navigationController pushViewController:providerDetailViewController animated:YES];  
} // showProviderInfo

-(void) showSubmitterInfo:(id)sender {
  // submitting user
  [userDetailViewController loadView];
  [userDetailViewController updateWithProperties:submitterProperties];
  
  [self.navigationController pushViewController:userDetailViewController animated:YES];      
} // showSubmitterInfo

-(void) showMonitoringStatusInfo:(id)sender {
  if (monitoringStatusInformationAvailable) {
    if (![monitoringStatusViewController view]) [monitoringStatusViewController loadView];
    dispatch_async(dispatch_queue_create("Fetch monitoring statuses", NULL), ^{
      NSString *serviceID = [[serviceListingProperties objectForKey:JSONResourceElement] lastPathComponent];
      [monitoringStatusViewController updateWithMonitoringStatusInfoForServiceWithID:[serviceID intValue]];
    });
    
    [self.navigationController pushViewController:monitoringStatusViewController animated:YES];
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
  NSURL *variantURL = [NSURL URLWithString:[[[serviceProperties objectForKey:JSONVariantsElement] lastObject] 
                                            objectForKey:JSONResourceElement]];
  NSString *path;
  if ([serviceListingProperties serviceListingIsRESTService]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
    serviceComponentsViewController.title = RESTComponentsText;
  } else {
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
    serviceComponentsViewController.title = SOAPComponentsText;
  }
  
  if (![serviceComponentsViewController view]) [serviceComponentsViewController loadView];
  dispatch_async(dispatch_queue_create("Fetch service components", NULL), ^{
    [serviceComponentsViewController updateWithServiceComponentsForPath:path];
  });
  
  [self.navigationController pushViewController:serviceComponentsViewController animated:YES];
} // showServiceComponents

-(void) makeShowProvidersButtonVisible:(BOOL)visible {
  providerButton.hidden = !visible;
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

