//
//  WebBrowserController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 10/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstants.h"


@interface WebBrowserController : NSObject <UIWebViewDelegate> {
  IBOutlet UIBarButtonItem *reloadButton;
  IBOutlet UIBarButtonItem *stopButton;
  IBOutlet UIBarButtonItem *backButton;
  IBOutlet UIBarButtonItem *forwardButton;
}

@end
