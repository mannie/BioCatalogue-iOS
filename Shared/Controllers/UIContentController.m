//
//  UIContentController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIContentController.h"

#import "DetailViewController_iPad.h"


@implementation UIContentController

@synthesize iPadDetailViewController;


+(void) customiseTableView:(UITableView *)tableView {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BrushedMetalBackground]];
    
  [tableView setBackgroundView:imageView];
  [tableView setBackgroundColor:[UIColor clearColor]];
  
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  [tableView setRowHeight:50];
  
  [imageView release];
} // setBrushedMetalBackground

+(void) customiseTableViewCell:(UITableViewCell *)cell {
  UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TableCellBackground]];
  [backgroundView setAlpha:0.25];
  [cell setBackgroundView:backgroundView];
  [backgroundView release];
  
  UIImageView *selectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TableCellSelectedBackground]];
  [cell setSelectedBackgroundView:selectionView];
  [selectionView release];  
} // customiseTableViewCell

+(void) populateTableViewCell:(UITableViewCell *)cell withObject:(id)object givenScope:(NSString *)scope {
  [self customiseTableViewCell:cell];
  
  if ([scope isEqualToString:ServiceResourceScope]) { // --- ServiceResourceScope
    NSDictionary *serviceProperties = (NSDictionary *)object;

    cell.textLabel.text = [serviceProperties objectForKey:JSONNameElement];
    cell.detailTextLabel.text = [serviceProperties serviceListingType];
    
    NSURL *imageURL = [NSURL URLWithString:[[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] 
                                            objectForKey:JSONSmallSymbolElement]];
    cell.imageView.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
    
    if ([[NSString stringWithFormat:@"%@", [serviceProperties objectForKey:JSONArchivedAtElement]] isValidJSONValue]) { 
      // is archived
      cell.imageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    } else {
      cell.imageView.backgroundColor = [UIColor clearColor];
    }
  } else if ([scope isEqualToString:UserResourceScope]) { // --- UserResourceScope
    NSDictionary *userProperties = (NSDictionary *)object;
    
    cell.textLabel.text = [userProperties objectForKey:JSONNameElement];

    NSString *affiliation = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
    cell.detailTextLabel.text = ([affiliation isValidJSONValue] ? affiliation : UnknownAffiliationText);  

    cell.imageView.image = [UIImage imageNamed:UserIcon];
  } else if ([scope isEqualToString:ProviderResourceScope]) { // --- ProviderResourceScope
    NSDictionary *providerProperties = (NSDictionary *)object;
    
    cell.textLabel.text = [providerProperties objectForKey:JSONNameElement];

//    NSString *description = [NSString stringWithFormat:@"%@", [providerProperties objectForKey:JSONDescriptionElement]];
//    description = [NSString stringWithFormat:@"About: %@", ([description isValidJSONValue] ? description : NoInformationText)];
//    cell.detailTextLabel.text = description;  

    cell.detailTextLabel.text = nil;
    cell.imageView.image = [UIImage imageNamed:ProviderIcon];
  } else if ([scope isEqualToString:AnnouncementResourceScope]) { // --- AnnouncementResourceScope
    Announcement *announcement = (Announcement *)object;
    cell.textLabel.text = announcement.title;
    
//    NSArray *date = [[announcement.date description] componentsSeparatedByString:@" "];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ at %@", [date objectAtIndex:0], [date objectAtIndex:1]];
    NSRange range = NSMakeRange(90, [announcement.summary length]-90);
    cell.detailTextLabel.text = [[announcement.summary stringByReplacingCharactersInRange:range withString:@""] stringByConvertingHTMLToPlainText];
    
    if ([announcement.isUnread boolValue]) {
      cell.imageView.image = [UIImage imageNamed:AnnouncementUnreadIcon];
      cell.imageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    } else {
      cell.imageView.image = [UIImage imageNamed:AnnouncementReadIcon];
      cell.imageView.backgroundColor = [UIColor clearColor];
    }
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
  [dateFormatter setDateFormat:JSONDateFormat];
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
      if ([[UIApplication sharedApplication] canOpenURL:[request mainDocumentURL]]) {
        [iPadDetailViewController showResourceInPullOutBrowser:[request mainDocumentURL]];
      } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Error"
                                                        message:@"Unable to open this URL."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
      }
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
