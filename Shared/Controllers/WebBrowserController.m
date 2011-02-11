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
  NSMutableArray *items = [[browserToolbar items] mutableCopy];
  NSUInteger indexToUpdate = [items count] - 1;

  [items removeObjectAtIndex:indexToUpdate]; 
  
  if (webView.loading) {
    [items insertObject:stopButton atIndex:indexToUpdate];
  } else {
    [items insertObject:refreshButton atIndex:indexToUpdate];
  }

  [browserToolbar setItems:items animated:YES];  
  [items release];

  backButton.enabled = webView.canGoBack;
  forwardButton.enabled = webView.canGoForward;
} // updateNavigationButtons

-(void) webViewDidStartLoad:(UIWebView *)webView {
  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];

  [webBrowserActivityIndicator startAnimating];
} // webViewDidStartLoad

-(void) webViewDidFinishLoad:(UIWebView *)webView {
  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];

  [webBrowserActivityIndicator stopAnimating];
} // webViewDidFinishLoad

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if ([error code] == -999) { // user stopped the browser from loading the current page
    [self webViewDidFinishLoad:webView];
    return;
  }
  
  NSLog(@"didFailLoadWithError: %@", error);
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error domain]
                                                  message:[NSString stringWithFormat:@"%@", [error localizedDescription]] 
                                                 delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
  [alert release];

  [self webViewDidFinishLoad:webView];
  return;
} // didFailLoadWithError


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [refreshButton release];
  [stopButton release];
  
  [backButton release];
  [forwardButton release];
  
  [browserToolbar release];
  [webBrowserActivityIndicator release];
 
  [super dealloc];
} // dealloc


@end
