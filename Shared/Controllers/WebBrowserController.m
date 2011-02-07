//
//  WebBrowserController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 10/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebBrowserController.h"


@implementation WebBrowserController

-(void) updateNavigationButtons:(UIWebView *)webView {
  UIImage *stopRefreshButtonImage;
  if (webView.loading) {
    stopRefreshButtonImage = [UIImage imageNamed:BrowserStopIcon];
    [stopRefreshButton setAction:@selector(stopLoading)];
  } else {
    stopRefreshButtonImage = [UIImage imageNamed:BrowserRefreshIcon];
    [stopRefreshButton setAction:@selector(reload)];
  }

  UIImageView *imageView = [[UIImageView alloc] initWithImage:stopRefreshButtonImage];
  [stopRefreshButton setCustomView:[imageView autorelease]];

  backButton.enabled = webView.canGoBack;
  forwardButton.enabled = webView.canGoForward;
} // updateNavigationButtons

-(void) webViewDidStartLoad:(UIWebView *)webView {
  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];

  NSLog(@"webViewDidStartLoad: %@", webView);  
} // webViewDidStartLoad

-(void) webViewDidFinishLoad:(UIWebView *)webView {
  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];

  NSLog(@"webViewDidFinishLoad: %@", webView);
} // webViewDidFinishLoad

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"didFailLoadWithError: %@", error);
  
  return;
  
  NSString *message = [NSString stringWithFormat:@"%@\n\n%@", 
                       [error localizedDescription], [error localizedRecoverySuggestion]];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error domain]
                                                  message:message 
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:nil];
  for (NSString *title in [error localizedRecoveryOptions]) {
    [alert addButtonWithTitle:title];
  }
  
  [alert show];
  [alert release];
} // didFailLoadWithError


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [stopRefreshButton release];
  
  [backButton release];
  [forwardButton release];
  
  [super dealloc];
} // dealloc


@end
