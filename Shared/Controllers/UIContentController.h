//
//  UIContentController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstants.h"

#import "NSString+Helper.h"
#import "NSDictionary+Helper.h"
#import "UIDevice+Helper.h"

#import "BioCatalogueClient.h"

#import "BioCatalogueResourceManager.h"
#import "NSString+HTML.h"

@class DetailViewController_iPad;


@interface UIContentController : NSObject <UIWebViewDelegate> {
  DetailViewController_iPad* iPadDetailViewController;
  
  // the service view
  IBOutlet UILabel *serviceName;
  IBOutlet UIWebView *serviceDescription;
  IBOutlet UILabel *serviceProviderName;
  IBOutlet UILabel *serviceSubmitterName;
  
  IBOutlet UILabel *serviceComponents;
  IBOutlet UIButton *showComponentsButton;

  IBOutlet UIImageView *monitoringStatusIcon;
  
  // user details
  IBOutlet UILabel *userName;
  IBOutlet UILabel *userAffiliation;
  IBOutlet UILabel *userCountry;
  IBOutlet UILabel *userCity;
  IBOutlet UILabel *userEmail;
  IBOutlet UILabel *userJoinedDate;
  
  // provider details
  IBOutlet UILabel *providerName;
  IBOutlet UIWebView *providerDescription;

  // announcements
  IBOutlet UILabel *announcementTitle;
  IBOutlet UILabel *announcementDate;
  IBOutlet UIWebView *announcementSummary;
}

@property(nonatomic, retain) IBOutlet DetailViewController_iPad* iPadDetailViewController;

+(void) customiseTableView:(UITableView *)tableView;

+(void) populateTableViewCell:(UITableViewCell *)cell withService:(Service *)service;
+(void) populateTableViewCell:(UITableViewCell *)cell withObject:(id)object givenScope:(NSString *)scope;

-(void) updateServiceUIElementsWithService:(Service *)service;
-(void) updateServiceUIElementsWithProperties:(NSDictionary *)listingProperties 
                                 providerName:(NSString *)providerName 
                                submitterName:(NSString *)submitterName 
                              showLoadingText:(BOOL)isBusy;
-(void) updateUserUIElementsWithProperties:(NSDictionary *)properties;
-(void) updateProviderUIElementsWithProperties:(NSDictionary *)properties;
-(void) updateAnnouncementUIElementsWithPropertiesForAnnouncementWithID:(NSUInteger)announcementID;

@end
