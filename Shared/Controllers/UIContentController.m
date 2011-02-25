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


typedef enum { 
  XIBCellMainIcon = 101, 
  XIBCellMainText,
  XIBCellDetailText, 
  XIBCellUpdateStatusIcon,
  XIBCellHorizontalLineImage, 
  XIBCellExtraDetailIcon } XIBTableViewCellTag;


+(void) customiseTableView:(UITableView *)tableView {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BrushedMetalBackground]];
    
  [tableView setBackgroundView:imageView];
  [tableView setBackgroundColor:[UIColor clearColor]];
  
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  [tableView setRowHeight:60];
  
  [imageView release];
} // setBrushedMetalBackground

+(void) customiseTableViewCell:(UITableViewCell *)cell {
  if (![cell backgroundView]) {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TableCellBackground]];
    [backgroundView setAlpha:0.3];
    [cell setBackgroundView:backgroundView];
    [backgroundView release];
    
    UIImageView *selectionView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TableCellSelectedBackground]];
    [cell setSelectedBackgroundView:selectionView];
    [selectionView release];          

    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setAlpha:0.5];
  }
} // customiseTableViewCell

+(void) populateTableViewCell:(UITableViewCell *)cell withObject:(id)object givenScope:(NSString *)scope {
  [self customiseTableViewCell:cell];
  
  if ([scope isEqualToString:ServiceResourceScope]) { // --- ServiceResourceScope
    NSDictionary *serviceProperties = (NSDictionary *)object;

    [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[serviceProperties objectForKey:JSONNameElement]];
    
    NSArray *date = [[serviceProperties objectForKey:JSONCreatedAtElement] 
                               componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet]];
    [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:[NSString stringWithFormat:@"Registered on %@", [date objectAtIndex:0]]];

    NSURL *imageURL = [NSURL URLWithString:[[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSymbolElement]];
    [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]]];

    if ([[NSString stringWithFormat:@"%@", [serviceProperties objectForKey:JSONArchivedAtElement]] isValidJSONValue]) { 
      // is archived
      [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreyLineImage]];      
    } else {
      [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreenLineImage]];
    }
    
    [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:NO];
    [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setImage:[UIImage imageNamed:[serviceProperties serviceListingType]]];

    int uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
    if ([BioCatalogueResourceManager serviceWithUniqueIDIsBeingMonitored:uniqueID]) {
      if ([[[BioCatalogueResourceManager serviceWithUniqueID:uniqueID] hasUpdate] boolValue]) {
        [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:NO];
      } else {
        [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];
      }
    } else {
      [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];
    }
  } else if ([scope isEqualToString:UserResourceScope]) { // --- UserResourceScope
    NSDictionary *userProperties = (NSDictionary *)object;
    
    [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[userProperties objectForKey:JSONNameElement]];
    
    NSString *affiliation = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
    [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:([affiliation isValidJSONValue] ? affiliation : UnknownAffiliationText)];
    
    [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[UIImage imageNamed:UserIcon]];
    
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreyLineImage]];      
    
    [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];
    
    [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];    
  } else if ([scope isEqualToString:ProviderResourceScope]) { // --- ProviderResourceScope
    NSDictionary *providerProperties = (NSDictionary *)object;

    [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[providerProperties objectForKey:JSONNameElement]];
    
    NSString *detail = [NSString stringWithFormat:@"%@", [providerProperties objectForKey:JSONDescriptionElement]];
    [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:([detail isValidJSONValue] ? detail : NoInformationText)];
    
    [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[UIImage imageNamed:ProviderIcon]];
    
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreyLineImage]];      

    [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];
    
    [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];    
  } else if ([scope isEqualToString:AnnouncementResourceScope]) { // --- AnnouncementResourceScope
    Announcement *announcement = (Announcement *)object;
    
    [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[announcement title]];
    
    NSRange range = NSMakeRange(90, [[announcement summary] length]-90);
    NSString *detail = [[[announcement summary] stringByReplacingCharactersInRange:range withString:@""] stringByConvertingHTMLToPlainText];
    [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:detail];
    
    if ([[announcement isUnread] boolValue]) { // is Unread
      [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[UIImage imageNamed:AnnouncementUnreadIcon]];
      [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreenLineImage]];
    } else { // has been read
      [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[UIImage imageNamed:AnnouncementReadIcon]];
      [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[UIImage imageNamed:GreyLineImage]];
    }
    [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:![[announcement isUnread] boolValue]];    
          
    [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];    
  }
} // customiseTableViewCell:withProperties:givenScope


#pragma mark -
#pragma mark UI Element Update

-(void) updateServiceUIElementsWithProperties:(NSDictionary *)listingProperties 
                                 providerName:(NSString *)provider 
                                submitterName:(NSString *)submitter 
                              showLoadingText:(BOOL)isBusy {
  [serviceDescription setDelegate:self];

  if (isBusy) {
    [serviceName setText:[listingProperties objectForKey:JSONNameElement]];
    
    NSString *description = [NSString stringWithFormat:@"%@", [listingProperties objectForKey:JSONDescriptionElement]];
    description = ([description isValidJSONValue] ? description : NoDescriptionText);
    [serviceDescription loadHTMLString:description baseURL:nil];
    [serviceDescription setBackgroundColor:[UIColor clearColor]];

    [serviceProviderName setText:DefaultLoadingText];
    [serviceSubmitterName setText:DefaultLoadingText];

    NSURL *imageURL = [NSURL URLWithString:
                       [[listingProperties objectForKey:JSONLatestMonitoringStatusElement] 
                        objectForKey:JSONSmallSymbolElement]];
    [monitoringStatusIcon setImage:[UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]]];
    
    // service components
    BOOL isREST = [listingProperties serviceListingIsRESTService];
    BOOL isSOAP = [listingProperties serviceListingIsSOAPService];
    
    if (isREST) {
      [serviceComponents setText:RESTComponentsText];
    } else if (isSOAP) {
      [serviceComponents setText:SOAPComponentsText];
    } else {
      [serviceComponents setText:nil];
    }
    
    [showComponentsButton setHidden:!isREST && !isSOAP];
  } else {
    [serviceProviderName setText:provider];
    [serviceSubmitterName setText:submitter];
  }
} // updateServiceUIElementsWithProperties:showLoadingText

-(void) updateUserUIElementsWithProperties:(NSDictionary *)properties {
  [userName setText:[properties objectForKey:JSONNameElement]];
  
  NSString *detailItem = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONAffiliationElement]];
  [userAffiliation setText:([detailItem isValidJSONValue] ? detailItem : UnknownText)];
  
  detailItem = [NSString stringWithFormat:@"%@", [[properties objectForKey:JSONLocationElement] objectForKey:JSONCountryElement]];
  [userCountry setText:([detailItem isValidJSONValue] ? detailItem : UnknownText)];
  
  detailItem = [NSString stringWithFormat:@"%@", [[properties objectForKey:JSONLocationElement] objectForKey:JSONCityElement]];
  [userCity setText:([detailItem isValidJSONValue] ? detailItem : UnknownText)];
  
  detailItem = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONPublicEmailElement]];
  [userEmail setText:([detailItem isValidJSONValue] ? detailItem : UnknownText)];
  
  NSArray *date = [[properties objectForKey:JSONJoinedElement] componentsSeparatedByCharactersInSet:[NSCharacterSet letterCharacterSet]]; 
  [userJoinedDate setText:[NSString stringWithFormat:@"%@ at %@", [date objectAtIndex:0], [date objectAtIndex:1]]];
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
    [BioCatalogueResourceManager commitChanges];  
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
