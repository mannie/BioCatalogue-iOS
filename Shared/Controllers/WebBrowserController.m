//
//  WebBrowserController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 10/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WebBrowserController.h"


@implementation WebBrowserController

-(void) webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"webViewDidStartLoad: %@", webView);
} // webViewDidStartLoad

-(void) webViewDidFinishLoad:(UIWebView *)webView {
  NSLog(@"webViewDidFinishLoad: %@", webView);
} // webViewDidFinishLoad

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  NSLog(@"shouldStartLoadWithRequest: %@", request);

  return YES;
} // shouldStartLoadWithRequest:navigationType

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  NSLog(@"didFailLoadWithError: %@", error);
  
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

@end
