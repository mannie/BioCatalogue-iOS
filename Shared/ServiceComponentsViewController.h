//
//  ServiceComponentsViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSON+Helper.h"
#import "NSString+Helper.h"

@class DetailViewController_iPad;


@interface ServiceComponentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  NSDictionary *componentsProperties;
  NSArray *serviceComponents;
  
  IBOutlet UITableView *myTableView;
  IBOutlet UILabel *loadingLabel;
  
  IBOutlet DetailViewController_iPad *iPadDetailViewController;

  IBOutlet UIViewController *iPhoneWebViewController;
  
  BOOL serviceIsREST;
}

-(void) fetchServiceComponents:(NSString *)fromPath;
-(void) updateWithProperties:(NSDictionary *)properties;

@end



@interface WebViewController_iPhone : UIViewController {
}
@end


