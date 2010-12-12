//
//  ServiceComponentsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebAccessController.h"


@class DetailViewController_iPad;


@interface ServiceComponentsViewController : UITableViewController {
  NSDictionary *componentsProperties;
  NSArray *serviceComponents;
  
  UIView *loadingView;
  
  IBOutlet DetailViewController_iPad *iPadDetailViewController;

  IBOutlet UIViewController *iPhoneWebViewController;

  IBOutlet UIActivityIndicatorView *activityIndicator;

  BOOL serviceIsREST;
  
  NSString *lastUsedPath;
}

-(void) fetchServiceComponents:(NSString *)fromPath;

@end



@interface WebViewController_iPhone : UIViewController {
}
@end


