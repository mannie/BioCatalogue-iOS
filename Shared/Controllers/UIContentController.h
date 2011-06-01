//
//  UIContentController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

@class DetailViewController_iPad, MailComposerViewController;


@interface UIContentController : NSObject <UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
  DetailViewController_iPad* iPadDetailViewController;
  
  // soap operation
  IBOutlet UILabel *operationName;
  IBOutlet UIWebView *opertionDescription;
  
  // rest methods/endpoints
  IBOutlet UILabel *endpointPrimaryName;
  IBOutlet UILabel *endpointSecondaryName;
  IBOutlet UIWebView *endpointDescription;
  
  // the service view
  IBOutlet UILabel *serviceName;
  IBOutlet UIWebView *serviceDescription;
  IBOutlet UILabel *serviceProviderName;
  IBOutlet UILabel *serviceSubmitterName;
  
  IBOutlet UILabel *serviceComponents;
  IBOutlet UIButton *showComponentsButton;
  IBOutlet UIButton *showSubmitterButton;
  
  IBOutlet UIImageView *monitoringStatusIcon;
  
  // user details
  IBOutlet UILabel *userName;
  IBOutlet UILabel *userAffiliation;
  IBOutlet UILabel *userCountry;
  IBOutlet UILabel *userCity;
  IBOutlet UILabel *userEmail;
  IBOutlet UILabel *userJoinedDate;
  
  IBOutlet UIButton *userEmailButton;
  IBOutlet UILabel *userEmailCaption;
  
  // provider details
  IBOutlet UILabel *providerName;
  IBOutlet UIWebView *providerDescription;

  // announcements
  IBOutlet UILabel *announcementTitle;
  IBOutlet UILabel *announcementDate;
  IBOutlet UIWebView *announcementSummary;
}

@property(nonatomic, retain) IBOutlet DetailViewController_iPad* iPadDetailViewController;

+(void) clearUIImageCache;

+(void) customiseTableView:(UITableView *)tableView;
+(void) customiseTableViewCell:(UITableViewCell *)cell;

+(void) populateTableViewCell:(UITableViewCell *)cell withObject:(id)object givenScope:(NSString *)scope;

-(void) updateServiceUIElementsWithProperties:(NSDictionary *)listingProperties 
                                 providerName:(NSString *)providerName 
                                submitterName:(NSString *)submitterName 
                              showLoadingText:(BOOL)isBusy;
-(void) updateUserUIElementsWithProperties:(NSDictionary *)properties;
-(void) updateProviderUIElementsWithProperties:(NSDictionary *)properties;
-(void) updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID;

-(void) updateRESTEndpointUIElementsWithProperties:(NSDictionary *)properties;
-(void) updateSOAPOperationUIElementsWithProperties:(NSDictionary *)properties;

-(void) composeMailMessage:(NSURL *)address;


@end
