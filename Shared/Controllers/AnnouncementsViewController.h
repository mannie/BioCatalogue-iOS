//
//  AnnouncementsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshViewController.h"

#import "BioCatalogueResourceManager.h"
#import "AppDelegate_Shared.h"

#import "DetailViewController_iPad.h"
#import "AnnouncementDetailViewController_iPhone.h"

#import "UpdateCenter.h"


@interface AnnouncementsViewController : PullToRefreshViewController <PullToRefreshDataSource, MWFeedParserDelegate> {
	NSArray *announcements;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;
@property (nonatomic, retain) IBOutlet AnnouncementDetailViewController_iPhone *iPhoneDetailViewController;

@end
