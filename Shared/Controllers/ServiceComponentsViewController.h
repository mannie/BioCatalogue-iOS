//
//  ServiceComponentsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 University of Manchester. All rights reserved.
//

@class SVWebViewController, ServiceComponentsDetailViewController;


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



