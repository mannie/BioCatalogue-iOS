//
//  UIContentController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

@class DetailViewController_iPad;


@interface UIContentController : NSObject <UIWebViewDelegate, MFMailComposeViewControllerDelegate> {
  DetailViewController_iPad* iPadDetailViewController;
  
  // soap operation
  IBOutlet UILabel *operationName;
  IBOutlet FlatWebView *opertionDescription;
  
  // rest methods/endpoints
  IBOutlet UILabel *endpointPrimaryName;
  IBOutlet UILabel *endpointSecondaryName;
  IBOutlet FlatWebView *endpointDescription;
  
  // the service view
  IBOutlet UILabel *serviceName;
  IBOutlet FlatWebView *serviceDescription;
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
  IBOutlet FlatWebView *providerDescription;
  IBOutlet UILabel *providerServiceCount;

  NSNumber *lowerBoundForProviderServiceCount;
  SEL showServicesSelector;
  id showServicesTarget;  
  
  // announcements
  IBOutlet UILabel *announcementTitle;
  IBOutlet UILabel *announcementDate;
  IBOutlet FlatWebView *announcementSummary;
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
-(void) composeMailMessage:(NSURL *)address subject:(NSString *)theSubject content:(NSString *)theMessage;

-(void) showServicesButtonGiven:(NSNumber *)lowerBound performingSelector:(SEL)aSelector onTarget:(id)target;


@end
