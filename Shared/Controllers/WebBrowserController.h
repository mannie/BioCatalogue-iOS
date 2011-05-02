//
//  WebBrowserController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 10/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//


@interface WebBrowserController : NSObject <UIWebViewDelegate> {
  IBOutlet UIToolbar *browserToolbar;
  IBOutlet UIActivityIndicatorView *webBrowserActivityIndicator;

  IBOutlet UIBarButtonItem *refreshButton;
  IBOutlet UIBarButtonItem *stopButton;
  IBOutlet UIBarButtonItem *backButton;
  IBOutlet UIBarButtonItem *forwardButton;
  
  UIContentController *contentController;
}

@end
