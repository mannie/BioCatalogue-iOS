//
//  UIContentController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIContentController.h"


@implementation UIContentController

@synthesize iPadDetailViewController;


+(void) setTableViewBackground:(UITableView *)tableView {
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BrushedMetalBackground]];
  
  image.frame = tableView.frame;
  
  [tableView setBackgroundView:image];
  [tableView setBackgroundColor:[UIColor clearColor]];
  
  [image release];
} // setBrushedMetalBackground

+(void) customiseTableViewCell:(UITableViewCell *)cell withService:(Service *)service {
  cell.textLabel.text = service.name;
  cell.detailTextLabel.text = service.about;
  cell.imageView.image = [UIImage imageWithData:service.latestMonitoringIcon];      
} // customiseTableViewCell:withService

+(void) customiseTableViewCell:(UITableViewCell *)cell 
                withProperties:(NSDictionary *)properties
                    givenScope:(NSString *)scope {
  if ([scope isEqualToString:ServiceResourceScope]) {    
    cell.textLabel.text = [properties objectForKey:JSONNameElement];
    cell.detailTextLabel.text = [properties serviceListingType];
    
    NSURL *imageURL = [NSURL URLWithString:[[properties objectForKey:JSONLatestMonitoringStatusElement] 
                                            objectForKey:JSONSmallSymbolElement]];
    cell.imageView.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];    
  } else if ([scope isEqualToString:UserResourceScope]) {
    cell.textLabel.text = [properties objectForKey:JSONNameElement];

    NSString *affiliation = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONAffiliationElement]];
    cell.detailTextLabel.text = ([affiliation isValidJSONValue] ? affiliation : UnknownAffiliationText);  

    cell.imageView.image = [UIImage imageNamed:UserIcon];
  } else if ([scope isEqualToString:ProviderResourceScope]) {
    cell.textLabel.text = [properties objectForKey:JSONNameElement];

//    NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
//    description = [NSString stringWithFormat:@"About: %@", ([description isValidJSONValue] ? description : NoInformationText)];
//    cell.detailTextLabel.text = description;  

    cell.detailTextLabel.text = nil;
    cell.imageView.image = [UIImage imageNamed:ProviderIcon];
  }
} // customiseTableViewCell:withProperties:givenScope


#pragma mark -
#pragma mark UI Element Update

-(void) updateServiceUIElementsWithProperties:(NSDictionary *)listingProperties 
                                 providerName:(NSString *)provider 
                                submitterName:(NSString *)submitter 
                              showLoadingText:(BOOL)isBusy {
  serviceDescription.delegate = self;

  if (isBusy) {
    serviceName.text = [listingProperties objectForKey:JSONNameElement];
    
    NSString *description = [NSString stringWithFormat:@"%@", [listingProperties objectForKey:JSONDescriptionElement]];
    description = ([description isValidJSONValue] ? description : NoDescriptionText);
    [serviceDescription loadHTMLString:description baseURL:nil];
    [serviceDescription setBackgroundColor:[UIColor clearColor]];

    serviceProviderName.text = DefaultLoadingText;
    serviceSubmitterName.text = DefaultLoadingText;

    NSURL *imageURL = [NSURL URLWithString:
                       [[listingProperties objectForKey:JSONLatestMonitoringStatusElement] 
                        objectForKey:JSONSmallSymbolElement]];
    monitoringStatusIcon.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
    
    // service components
    BOOL isREST = [listingProperties serviceListingIsRESTService];
    BOOL isSOAP = [listingProperties serviceListingIsSOAPService];
    
    if (isREST) {
      serviceComponents.text = RESTComponentsText;
    } else if (isSOAP) {
      serviceComponents.text = SOAPComponentsText;
    } else {
      serviceComponents.text = nil;
    }
    
    showComponentsButton.hidden = !isREST && !isSOAP;    
  } else {
    serviceProviderName.text = provider;
    serviceSubmitterName.text = submitter;
  }
} // updateServiceUIElementsWithProperties:showLoadingText

-(void) updateUserUIElementsWithProperties:(NSDictionary *)properties {
  userName.text = [properties objectForKey:JSONNameElement];
  
  NSString *detailItem = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONAffiliationElement]];
  userAffiliation.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [[properties objectForKey:JSONLocationElement] 
                                              objectForKey:JSONCountryElement]];
  userCountry.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [[properties objectForKey:JSONLocationElement] 
                                              objectForKey:JSONCityElement]];
  userCity.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  detailItem = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONPublicEmailElement]];
  userEmail.text = ([detailItem isValidJSONValue] ? detailItem : UnknownText);
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
  NSArray *date = [[[dateFormatter dateFromString:[properties objectForKey:JSONJoinedElement]] description] 
                   componentsSeparatedByString:@" "];
    
  detailItem = [NSString stringWithFormat:@"%@ at %@", [date objectAtIndex:0], [date objectAtIndex:1]];
  userJoinedDate.text = detailItem;
  [dateFormatter release];
} // updateUserProviderUIElementsWithProperties

-(void) updateProviderUIElementsWithProperties:(NSDictionary *)properties {
  providerDescription.delegate = self;

  providerName.text = [properties objectForKey:JSONNameElement];
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  description = ([description isValidJSONValue] ? description : NoInformationText);  
  [providerDescription loadHTMLString:description baseURL:nil];
  [providerDescription setBackgroundColor:[UIColor clearColor]];
} // updateProviderUIElementsWithProperties

-(void) updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {  
  announcementSummary.delegate = self;

  Announcement *announcement = [BioCatalogueResourceManager announcementWithUniqueID:announcementID];
  
  [announcementSummary loadHTMLString:announcement.summary baseURL:nil];
  [announcementSummary setBackgroundColor:[UIColor clearColor]];
  
  announcementTitle.text = announcement.title;
  
  NSArray *date = [[announcement.date description] componentsSeparatedByString:@" "];
  announcementDate.text = [NSString stringWithFormat:@"%@ at %@", [date objectAtIndex:0], [date objectAtIndex:1]];
  
  if ([announcement.isUnread boolValue]) {
    announcement.isUnread = [NSNumber numberWithBool:![announcement.isUnread boolValue]];
    [BioCatalogueResourceManager commmitChanges];  
  }
} // updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID


#pragma mark -
#pragma mark UI Web View Delegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  BOOL isMyRequest = [[[request mainDocumentURL] scheme] isEqualToString:@"about"];
  
  if (isMyRequest) {
    return YES;
  } else {
    if ([[UIDevice currentDevice] isIPadDevice]) {
      [iPadDetailViewController showResourceInPullOutBrowser:[request mainDocumentURL]];
    } else {
      [[UIApplication sharedApplication] openURL:[request mainDocumentURL]];
    }

    return NO;
  }
}



#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  [iPadDetailViewController release];
  
  // service detail outlets  
  [serviceName release];
  [serviceDescription release];
  [serviceProviderName release];
  [serviceSubmitterName release];
  
  [serviceComponents release];
  [showComponentsButton release];

  [monitoringStatusIcon release];
  
  // user detail outlets
  [userName release];
  [userAffiliation release];
  [userCountry release];
  [userCity release];
  [userEmail release];
  [userJoinedDate release];  
  
  // provider detail outlets
  [providerName release];
  [providerDescription release];
    
  // announcements
  [announcementTitle release];
  [announcementDate release];
  [announcementSummary release];

  [super dealloc];
} // dealloc


@end
