//
//  AnnouncementsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

@class DetailViewController_iPad, AnnouncementDetailViewController_iPhone;


@interface AnnouncementsViewController : PullToRefreshViewController <PullToRefreshDataSource, MWFeedParserDelegate> {
	NSArray *announcements;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, retain) IBOutlet DetailViewController_iPad *iPadDetailViewController;
@property (nonatomic, retain) IBOutlet AnnouncementDetailViewController_iPhone *iPhoneDetailViewController;

@end
