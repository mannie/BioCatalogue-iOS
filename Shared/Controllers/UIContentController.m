//
//  UIContentController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation UIContentController

@synthesize iPadDetailViewController;

typedef enum { 
  XIBCellMainIcon = 101, 
  XIBCellMainText,
  XIBCellDetailText, 
  XIBCellUpdateStatusIcon,
  XIBCellHorizontalLineImage, 
  XIBCellExtraDetailIcon } XIBTableViewCellTag;


static UIImage *_greyLineUIImage = nil;
static UIImage *_greenLineUIImage = nil;
static UIImage *_redLineUIImage = nil;

static UIImage *_restServiceUIImage = nil;
static UIImage *_soapServiceUIImage = nil;
static UIImage *_otherServiceUIImage = nil;

static UIImage *_tickUIImage = nil;
static UIImage *_plingUIImage = nil;
static UIImage *_crossUIImage = nil;
static UIImage *_queryUIImage = nil;

static UIImage *_userIconUIImage = nil;
static UIImage *_providerIconUIImage = nil;

static UIImage *_cellBackgroudUIImage = nil;
static UIImage *_cellSelectionBackgroudUIImage = nil;

static UIImage *_announcementReadIconUIImage = nil;
static UIImage *_announcementUnreadIconUIImage = nil;


#pragma mark -
#pragma mark Cached UIImages

+(void) clearUIImageCache {
  [_greyLineUIImage release];
  [_greenLineUIImage release];
  [_redLineUIImage release];

  [_restServiceUIImage release];
  [_soapServiceUIImage release];
  [_otherServiceUIImage release];

  [_tickUIImage release];
  [_plingUIImage release];
  [_crossUIImage release];
  [_queryUIImage release];

  [_userIconUIImage release];
  [_providerIconUIImage release];

  [_cellBackgroudUIImage release];
  [_cellSelectionBackgroudUIImage release];

  [_announcementReadIconUIImage release];
  [_announcementUnreadIconUIImage release];

  _greyLineUIImage = nil;
  _greenLineUIImage = nil;
  _redLineUIImage = nil;
  
  _restServiceUIImage = nil;
  _soapServiceUIImage = nil;
  _otherServiceUIImage = nil;
  
  _tickUIImage = nil;
  _plingUIImage = nil;
  _crossUIImage = nil;
  _queryUIImage = nil;
  
  _userIconUIImage = nil;
  _providerIconUIImage = nil;
  
  _cellBackgroudUIImage = nil;
  _cellSelectionBackgroudUIImage = nil;
  
  _announcementReadIconUIImage = nil;
  _announcementUnreadIconUIImage = nil;
} // clearUIImageCache

+(UIImage *) userIcon {
  if (_userIconUIImage) return _userIconUIImage;
  _userIconUIImage = [[UIImage imageNamed:UserIcon] retain];
  return _userIconUIImage;
} // userIcon

+(UIImage *) providerIcon {
  if (_providerIconUIImage) return _providerIconUIImage;
  _providerIconUIImage = [[UIImage imageNamed:ProviderIcon] retain];
  return _providerIconUIImage;
} // providerIcon

+(UIImage *) greyLineUIImage {
  if (_greyLineUIImage) return _greyLineUIImage;
  _greyLineUIImage = [[UIImage imageNamed:GreyLineImage] retain];
  return _greyLineUIImage;
} // greyLineUIImage

+(UIImage *) greenLineUIImage {
  if (_greenLineUIImage) return _greenLineUIImage;
  _greenLineUIImage = [[UIImage imageNamed:GreenLineImage] retain];
  return _greenLineUIImage;
} // greenLineUIImage

+(UIImage *) redLineUIImage {
  if (_redLineUIImage) return _redLineUIImage;
  _redLineUIImage = [[UIImage imageNamed:RedLineImage] retain];
  return _redLineUIImage;  
} // redLineUIImage

+(UIImage *) serviceListingTypeIcon:(NSDictionary *)serviceProperties {
  if ([[serviceProperties serviceListingType] isEqualToString:RESTService]) {
    if (_restServiceUIImage) return _restServiceUIImage;
    _restServiceUIImage = [[UIImage imageNamed:RESTService] retain];
    return _restServiceUIImage;  
  } else if ([[serviceProperties serviceListingType] isEqualToString:SOAPService]) {
    if (_soapServiceUIImage) return _soapServiceUIImage;
    _soapServiceUIImage = [[UIImage imageNamed:SOAPService] retain];
    return _soapServiceUIImage;  
  } else {
    if (_otherServiceUIImage) return _otherServiceUIImage;
    _otherServiceUIImage = [[UIImage imageNamed:[serviceProperties serviceListingType]] retain];
    return _otherServiceUIImage;  
  }  
} // serviceListingTypeUIImage

+(UIImage *) monitoringStatusUIImage:(NSString *)filename {
  filename = [filename stringByReplacingOccurrencesOfString:@"small-" withString:@""];
  
  if ([filename hasPrefix:@"tick"]) {
    if (_tickUIImage) return _tickUIImage;
    _tickUIImage = [[UIImage imageNamed:filename] retain];
    return _tickUIImage;
  } else if ([filename hasPrefix:@"pling"]) {
    if (_plingUIImage) return _plingUIImage;
    _plingUIImage = [[UIImage imageNamed:filename] retain];
    return _plingUIImage;
  } else if ([filename hasPrefix:@"cross"]) {
    if (_crossUIImage) return _crossUIImage;
    _crossUIImage = [[UIImage imageNamed:filename] retain];
    return _crossUIImage;
  } else {
    if (_queryUIImage) return _queryUIImage;
    _queryUIImage = [[UIImage imageNamed:filename] retain];
    return _queryUIImage;
  }
}

+(UIImage *) readAnnouncementIcon {
  if (_announcementReadIconUIImage) return _announcementReadIconUIImage;
  _announcementReadIconUIImage = [[UIImage imageNamed:AnnouncementReadIcon] retain];
  return _announcementReadIconUIImage;
} // readAnnouncementIcon

+(UIImage *) unreadAnnouncementIcon {
  if (_announcementUnreadIconUIImage) return _announcementUnreadIconUIImage;
  _announcementUnreadIconUIImage = [[UIImage imageNamed:AnnouncementUnreadIcon] retain];
  return _announcementUnreadIconUIImage;
} // unreadAnnouncementIcon

+(UIImage *) cellBackgroudUIImage {
  if (_cellBackgroudUIImage) return _cellBackgroudUIImage;
  _cellBackgroudUIImage = [[UIImage imageNamed:TableCellBackground] retain];
  return _cellBackgroudUIImage;
} // cellBackgroudUIImage

+(UIImage *) cellSelectionBackgroudUIImage {
  if (_cellSelectionBackgroudUIImage) return _cellSelectionBackgroudUIImage;
  _cellSelectionBackgroudUIImage = [[UIImage imageNamed:TableCellSelectedBackground] retain];
  return _cellSelectionBackgroudUIImage;
} // cellSelectionBackgroudUIImage


#pragma mark -
#pragma mark "Local" Helpers

+(void) populateServiceTableViewCell:(UITableViewCell *)cell withObject:(id)object {
  NSDictionary *serviceProperties = (NSDictionary *)object;
  
  [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[serviceProperties objectForKey:JSONNameElement]];
  
  NSString *date = [[serviceProperties objectForKey:JSONCreatedAtElement] stringByReformattingJSONDate:NO];
  [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:[NSString stringWithFormat:@"Registered on %@", date]];
  
  NSURL *imageURL = [NSURL URLWithString:[[serviceProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSymbolElement]];
  [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[self monitoringStatusUIImage:[imageURL lastPathComponent]]];
  
  int uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
  BOOL serviceIsBeingMonitored = [BioCatalogueResourceManager serviceWithUniqueIDIsBeingMonitored:uniqueID];
  
  if ([[NSString stringWithFormat:@"%@", [serviceProperties objectForKey:JSONArchivedAtElement]] isValidJSONValue]) { 
    // is archived
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self redLineUIImage]];      
  } else if (serviceIsBeingMonitored) {
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greenLineUIImage]];
  } else {
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greyLineUIImage]];
  }
  
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:NO];
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setImage:[self serviceListingTypeIcon:serviceProperties]];
  
  if (serviceIsBeingMonitored) {
    if ([[[BioCatalogueResourceManager serviceWithUniqueID:uniqueID] hasUpdate] boolValue]) {
      [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:NO];
    } else {
      [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];
    }
  } else {
    [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];
  }  
} // populateServiceTableViewCell:withObject

+(void) populateUserTableViewCell:(UITableViewCell *)cell withObject:(id)object {
  NSDictionary *userProperties = (NSDictionary *)object;
  
  [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[userProperties objectForKey:JSONNameElement]];
  
  NSString *affiliation = [NSString stringWithFormat:@"%@", [userProperties objectForKey:JSONAffiliationElement]];
  [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:([affiliation isValidJSONValue] ? affiliation : UnknownAffiliationText)];
  
  [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[self userIcon]];
  
  [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greyLineUIImage]];      
  
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];
  
  [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];  
} // populateUserTableViewCell:withObject

+(void) populateProviderTableViewCell:(UITableViewCell *)cell withObject:(id)object {
  NSDictionary *providerProperties = (NSDictionary *)object;
  
  [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[providerProperties objectForKey:JSONNameElement]];
  
  NSString *detail = [NSString stringWithFormat:@"%@", [providerProperties objectForKey:JSONDescriptionElement]];
  [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:([detail isValidJSONValue] ? detail : NoInformationText)];
  
  [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[self providerIcon]];
  
  [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greyLineUIImage]];      
  
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];
  
  [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];    
} // populateProviderTableViewCell:withObject

+(void) populateAnnouncementTableViewCell:(UITableViewCell *)cell withObject:(id)object {
  Announcement *announcement = (Announcement *)object;
  
  [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:[announcement title]];
  
  int stringLength = [[announcement summary] length];
  NSRange range = (stringLength > 90 ? NSMakeRange(90, [[announcement summary] length]-90) : NSMakeRange(stringLength - 1, 0));
  NSString *detail = [[[announcement summary] stringByReplacingCharactersInRange:range withString:@""] stringByConvertingHTMLToPlainText];
  [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:detail];
  
  if ([[announcement isUnread] boolValue]) { // is Unread
    [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[self unreadAnnouncementIcon]];
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greenLineUIImage]];
  } else { // has been read
    [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:[self readAnnouncementIcon]];
    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greyLineUIImage]];
  }
  [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:![[announcement isUnread] boolValue]];    
  
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];    
} // populateAnnouncementTableViewCell:withObject

+(void) populateScopelessTableViewCell:(UITableViewCell *)cell withObject:(id)object {
  [((UILabel *)[cell viewWithTag:XIBCellMainText]) setText:nil];
  
  [((UILabel *)[cell viewWithTag:XIBCellDetailText]) setText:nil];
  
  [((UIImageView *)[cell viewWithTag:XIBCellMainIcon]) setImage:nil];
  [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setImage:[self greyLineUIImage]];
  
  [((UIImageView *)[cell viewWithTag:XIBCellUpdateStatusIcon]) setHidden:YES];
  
  [((UIImageView *)[cell viewWithTag:XIBCellExtraDetailIcon]) setHidden:YES];    
} // populateScopelessTableViewCell:withObject


#pragma mark -
#pragma mark Global Helpers

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
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[self cellBackgroudUIImage]];
    [backgroundView setAlpha:0.3];
    [cell setBackgroundView:backgroundView];
    [backgroundView release];
    
    UIImageView *selectionView = [[UIImageView alloc] initWithImage:[self cellSelectionBackgroudUIImage]];
    [cell setSelectedBackgroundView:selectionView];
    [selectionView release];          

    [((UIImageView *)[cell viewWithTag:XIBCellHorizontalLineImage]) setAlpha:0.4];
  }
} // customiseTableViewCell

+(void) populateTableViewCell:(UITableViewCell *)cell withObject:(id)object givenScope:(NSString *)scope {
  [self customiseTableViewCell:cell];
  
  if ([scope isEqualToString:ServiceResourceScope]) { // --- ServiceResourceScope
    [self populateServiceTableViewCell:cell withObject:object];
  } else if ([scope isEqualToString:UserResourceScope]) { // --- UserResourceScope
    [self populateUserTableViewCell:cell withObject:object];
  } else if ([scope isEqualToString:ProviderResourceScope]) { // --- ProviderResourceScope
    [self populateProviderTableViewCell:cell withObject:object];
  } else if ([scope isEqualToString:AnnouncementResourceScope]) { // --- AnnouncementResourceScope
    [self populateAnnouncementTableViewCell:cell withObject:object];
  } else {
    [self populateScopelessTableViewCell:cell withObject:object];
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
    [serviceDescription performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor clearColor] waitUntilDone:NO];

    [serviceProviderName setText:DefaultLoadingText];
    [serviceSubmitterName setText:DefaultLoadingText];

    NSURL *imageURL = [NSURL URLWithString:[[listingProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSymbolElement]];
    [monitoringStatusIcon setImage:[UIImage imageNamed:[imageURL lastPathComponent]]];
    
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

    [showSubmitterButton setHidden:[submitter isRegistryName]];
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
  BOOL showEmail = [detailItem isValidJSONValue];
  [userEmail setText:(showEmail ? detailItem : nil)];
  [userEmailButton setHidden:!showEmail];
  [userEmailCaption setHidden:!showEmail];
  
  [userJoinedDate setText:[[properties objectForKey:JSONJoinedElement] stringByReformattingJSONDate:YES]];
} // updateUserProviderUIElementsWithProperties

-(void) updateProviderUIElementsWithProperties:(NSDictionary *)properties {
  [providerDescription setDelegate:self];

  [providerName setText:[properties objectForKey:JSONNameElement]];
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  description = ([description isValidJSONValue] ? description : NoInformationText);  
  [providerDescription loadHTMLString:description baseURL:nil];
  [providerDescription performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor clearColor] waitUntilDone:NO];
} // updateProviderUIElementsWithProperties

-(void) updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID {  
  [announcementSummary setDelegate:self];

  Announcement *announcement = [BioCatalogueResourceManager announcementWithUniqueID:announcementID];
  
  [announcementSummary loadHTMLString:[announcement summary] baseURL:nil];
  [announcementSummary performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor clearColor] waitUntilDone:NO];
  
  [announcementTitle performSelectorOnMainThread:@selector(setText:) withObject:[announcement title] waitUntilDone:NO];  
  
  NSArray *date = [[[announcement date] description] componentsSeparatedByString:@" "];
  NSString *dateText = [NSString stringWithFormat:@"%@ at %@", [[date objectAtIndex:0] stringByReformattingJSONDate:NO], [date objectAtIndex:1]];
  [announcementDate performSelectorOnMainThread:@selector(setText:) withObject:dateText waitUntilDone:NO];
  
  if ([[announcement isUnread] boolValue]) {
    [announcement setIsUnread:[NSNumber numberWithBool:![[announcement isUnread] boolValue]]];
    [BioCatalogueResourceManager commitChanges];  
  }
} // updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID

-(void) updateRESTEndpointUIElementsWithProperties:(NSDictionary *)properties {
  NSString *endpointLabel = [properties objectForKey:JSONEndpointLabelElement];
  NSString *name = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONNameElement]];
  
  if ([name isValidJSONValue]) {
    [endpointPrimaryName setText:name];
    [endpointSecondaryName setText:endpointLabel];
  } else {
    [endpointPrimaryName setText:endpointLabel];
    [endpointSecondaryName setText:NoAlternativeNameText];
  }
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  description = ([description isValidJSONValue] ? description : NoDescriptionText);
  [endpointDescription loadHTMLString:description baseURL:nil];
  [endpointDescription performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor clearColor] waitUntilDone:NO];
} // updateRESTEndpointUIElementsWithProperties

-(void) updateSOAPOperationUIElementsWithProperties:(NSDictionary *)properties {
  [operationName setText:[properties objectForKey:JSONNameElement]];
  
  NSString *description = [NSString stringWithFormat:@"%@", [properties objectForKey:JSONDescriptionElement]];
  description = ([description isValidJSONValue] ? description : NoDescriptionText);
  [opertionDescription loadHTMLString:description baseURL:nil];
  [opertionDescription performSelectorOnMainThread:@selector(setBackgroundColor:) withObject:[UIColor clearColor] waitUntilDone:NO];
} // updateSOAPOperationUIElementsWithProperties


#pragma mark -
#pragma mark Instance Helpers

-(void) composeMailMessage:(NSURL *)address {
  if (![MFMailComposeViewController canSendMail]) {
    [[UIApplication sharedApplication] openURL:address];    
    return;
  }
  
  MFMailComposeViewController *mailComposerViewController = [[MFMailComposeViewController alloc] init];
  [mailComposerViewController setMailComposeDelegate:self];
  
  NSString *emailAddress = [[address absoluteString] stringByReplacingOccurrencesOfString:@"mailto:" withString:@""];
  [mailComposerViewController setToRecipients:[NSArray arrayWithObject:emailAddress]];
  [mailComposerViewController setMessageBody:@"\n\n\n\n\n" isHTML:NO];
  
  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  [[appDelegate tabBarController] presentModalViewController:mailComposerViewController animated:YES];
  
  [mailComposerViewController becomeFirstResponder];
  [mailComposerViewController release];
} // composeMailMessage


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  switch (result) {
    case MFMailComposeResultCancelled: [@"MFMailComposeResultCancelled" log];
      break;
    case MFMailComposeResultSaved: [@"MFMailComposeResultSaved" log];
      break;
    case MFMailComposeResultSent: [@"MFMailComposeResultSent" log];
      break;
    case MFMailComposeResultFailed: 
      [error log];
      
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error sending eMail" 
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
      [alert release];
      
      break;
  }
   
  [controller resignFirstResponder];

  AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
  [[appDelegate tabBarController] dismissModalViewControllerAnimated:YES];
} 


#pragma mark -
#pragma mark UI Web View Delegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  BOOL isMyRequest = [[[request mainDocumentURL] scheme] isEqualToString:@"about"];
  if (isMyRequest) return YES;

  if ([[UIApplication sharedApplication] canOpenURL:[request mainDocumentURL]]) {
    if ([[UIDevice currentDevice] isIPadDevice]) {
      if (!iPadDetailViewController) {
        AppDelegate_iPad *appDelegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
        iPadDetailViewController = (DetailViewController_iPad *)[[[appDelegate splitViewController] viewControllers] lastObject];
      }
      
      if ([[[request mainDocumentURL] scheme] isEqualToString:@"mailto"]) {
        [self composeMailMessage:[request mainDocumentURL]];
      } else {
        [iPadDetailViewController showResourceInPullOutBrowser:[request mainDocumentURL]];
      }
    } else { // is not iPad
      if ([[[request mainDocumentURL] scheme] isEqualToString:@"mailto"]) {
        [self composeMailMessage:[request mainDocumentURL]];
      } else {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:[[request mainDocumentURL] absoluteString]];

        AppDelegate_Shared *appDelegate = (AppDelegate_Shared *)[[UIApplication sharedApplication] delegate];
        [[appDelegate tabBarController] presentModalViewController:webViewController animated:YES];
        
        [webViewController release];        
      }
    }
  } else { // cannot open url
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Error"
                                                    message:@"Unable to open this URL."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  
  return NO;
}


#pragma mark -
#pragma mark Memory Management

-(void) dealloc {
  [iPadDetailViewController release];
  
  // soap operation outlets
  [operationName release];
  [opertionDescription release];
    
  // rest methods/endpoints outlets
  [endpointPrimaryName release];
  [endpointSecondaryName release];
  [endpointDescription release];
  
  // service detail outlets  
  [serviceName release];
  [serviceDescription release];
  [serviceProviderName release];
  [serviceSubmitterName release];
  
  [serviceComponents release];
  [showComponentsButton release];
  [showSubmitterButton release];
  
  [monitoringStatusIcon release];
  
  // user detail outlets
  [userName release];
  [userAffiliation release];
  [userCountry release];
  [userCity release];
  [userEmail release];
  [userJoinedDate release];  
  
  [userEmailButton release];
  [userEmailCaption release];
  
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
