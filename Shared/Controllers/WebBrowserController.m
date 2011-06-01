//
//  WebBrowserController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 10/12/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation WebBrowserController


-(void) updateNavigationButtons:(UIWebView *)webView {  
  NSMutableArray *items = [[browserToolbar items] mutableCopy];
  NSUInteger indexToUpdate = [items count] - 1;
  
  [items removeObjectAtIndex:indexToUpdate]; 
  
  if ([webView isLoading]) {
    [items insertObject:stopButton atIndex:indexToUpdate];
  } else {
    [items insertObject:refreshButton atIndex:indexToUpdate];
  }
  
  [browserToolbar setItems:items animated:YES];  
  [items release];
  
  [backButton setEnabled:[webView canGoBack]];
  [forwardButton setEnabled:[webView canGoForward]];
} // updateNavigationButtons

-(void) webViewDidStartLoad:(UIWebView *)webView {
  [webView setBackgroundColor:[UIColor clearColor]];

  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStarted object:nil];
  
  [webBrowserActivityIndicator startAnimating];
  [loadedPageLabel setText:DefaultLoadingText];
} // webViewDidStartLoad

-(void) webViewDidFinishLoad:(UIWebView *)webView {
  [self updateNavigationButtons:webView];
  [[NSNotificationCenter defaultCenter] postNotificationName:NetworkActivityStopped object:nil];
  
  [webBrowserActivityIndicator stopAnimating];
  [loadedPageLabel setText:[[[webView request] mainDocumentURL] absoluteString]];
} // webViewDidFinishLoad

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if ([error code] == -999) { // user stopped the browser from loading the current page
    [self webViewDidFinishLoad:webView];
    return;
  }
  
  [error log];
  
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

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  if ([[[request mainDocumentURL] scheme] isEqualToString:@"mailto"]) {
    if (contentController) [contentController release];
    contentController = [[UIContentController alloc] init];
    [contentController composeMailMessage:[request mainDocumentURL]];
    
    return NO;
  }
  
  return YES;
} // webView:shouldStartLoadWithRequest:navigationType


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [contentController release];
  
  [refreshButton release];
  [stopButton release];
  
  [backButton release];
  [forwardButton release];
  
  [browserToolbar release];
  [webBrowserActivityIndicator release];
  
  [loadedPageLabel release];
  
  [super dealloc];
} // dealloc


@end
