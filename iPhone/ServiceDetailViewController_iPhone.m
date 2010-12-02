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

// TODO: split this up into smaller components so that this can be run properly from any thread
-(void) updateWithProperties:(NSDictionary *)properties {  
  serviceListingProperties = [properties copy];
  
  nameLabel.text = [serviceListingProperties objectForKey:JSONNameElement];
  
  [serviceProperties release];
  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  serviceProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
  
  // provider details
  NSString *detailItem = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                           objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
  providerNameLabel.text = detailItem;
  
  // monitoring details
  NSString *lastChecked = [NSString stringWithFormat:@"%@", 
                           [[properties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLastCheckedElement]];
  monitoringStatusInformationAvailable = [lastChecked isValidJSONValue];
  
  // submitter details
  [submitterProperties release];
  NSURL *submitterURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
  submitterProperties = [[[JSON_Helper helper] documentAtPath:[submitterURL path]] copy];
  
  submitterNameLabel.text = [submitterProperties objectForKey:JSONNameElement];
  
  detailItem = [NSString stringWithFormat:@"%@", [serviceListingProperties objectForKey:JSONDescriptionElement]];
  descriptionLabel.text = ([detailItem isValidJSONValue] ? detailItem : NoDescriptionText);
  
  // service components
  BioCatalogueClient *client = [BioCatalogueClient client];
  BOOL isREST = [client serviceIsREST:serviceListingProperties];
  BOOL isSOAP = [client serviceIsSOAP:serviceListingProperties];
  
  if (isREST) {
    componentsLabel.text = RESTComponentsText;
  } else if (isSOAP) {
    componentsLabel.text = SOAPComponentsText;
  } else {
    componentsLabel.text = [client serviceType:serviceListingProperties];
  }
  
  showComponentsButton.hidden = !isREST && !isSOAP;
  [self.view setNeedsDisplay];
} // updateWithProperties


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
} // viewDidLoad

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
    NSURL *serviceURL = [NSURL URLWithString:[serviceListingProperties objectForKey:JSONResourceElement]];
    NSString *path = [[serviceURL path] stringByAppendingPathComponent:@"monitoring"];
    
    [NSOperationQueue addToNewQueueSelector:@selector(fetchMonitoringStatusInfo:)
                                   toTarget:monitoringStatusViewController
                                 withObject:path];
    
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
  if ([[BioCatalogueClient client] serviceIsREST:serviceListingProperties]) {
    path = [[variantURL path] stringByAppendingPathComponent:@"methods"];
    serviceComponentsViewController.title = RESTComponentsText;
  } else {
    path = [[variantURL path] stringByAppendingPathComponent:@"operations"];
    serviceComponentsViewController.title = SOAPComponentsText;
  }
  
  [NSOperationQueue addToNewQueueSelector:@selector(fetchServiceComponents:)
                                 toTarget:serviceComponentsViewController
                               withObject:path];
  
  [self.navigationController pushViewController:serviceComponentsViewController animated:YES];
} // showServiceComponents


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [userDetailViewController release];
  [providerDetailViewController release];  
  [monitoringStatusViewController release];
  [serviceComponentsViewController release];
  
  [myTableView release];
  
  [nameLabel release];
  [descriptionLabel release];
  [providerNameLabel release];
  [submitterNameLabel release];
  [componentsLabel release];
  [showComponentsButton release];
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  
  [serviceListingProperties release];
  [serviceProperties release];
  [submitterProperties release];
  
  [super dealloc];
} // dealloc


@end

