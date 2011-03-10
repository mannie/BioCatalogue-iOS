//
//  ServiceComponentsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@class WebViewController_iPhone, ServiceComponentsDetailViewController;


@interface ServiceComponentsViewController : UITableViewController {
  NSString *currentPath;
  
  NSMutableDictionary *serviceComponentsInfo;
  NSArray *serviceComponents;
  
  IBOutlet UIActivityIndicatorView *activityIndicator;
    
  BOOL serviceIsREST;

  ServiceComponentsDetailViewController *detailViewController;
  
  BOOL viewHasBeenUpdated;
  BOOL currentlyFetchingComponents;
}

-(void) updateWithServiceComponentsForPath:(NSString *)path;

@property (nonatomic, retain) IBOutlet ServiceComponentsDetailViewController *detailViewController;

@end



@interface WebViewController_iPhone : UIViewController
@end


