//
//  ServiceComponentsViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServiceComponentsViewController.h"
#import "DetailViewController_iPad.h"


@implementation ServiceComponentsViewController


#pragma mark -
#pragma mark Helpers

-(void) updateWithProperties:(NSDictionary *)properties {  
  [componentsProperties release];
  componentsProperties = [properties retain];
  
  [serviceComponents release];
  if (serviceIsREST) {
    serviceComponents = [[properties objectForKey:JSONMethodsElement] retain];
  } else {
    serviceComponents = [[properties objectForKey:JSONOperationsElement] retain];
  }  

  fetching = NO;
  
  [myTableView reloadData];
  [myTableView setTableHeaderView:nil];
} // updateWithProperties

-(void) fetchServiceComponents:(NSString *)fromPath {  
  if (![lastUsedPath isEqualToString:fromPath]) {
    fetching = YES;

    [lastUsedPath release];
    lastUsedPath = [[NSString stringWithString:fromPath] retain];

    serviceIsREST = [[fromPath lastPathComponent] isEqualToString:@"methods"];
    
    [myTableView reloadData];
    [self updateWithProperties:[[JSON_Helper helper] documentAtPath:fromPath]];
  }
  
  if ([[UIDevice currentDevice] isIPadDevice]) [iPadDetailViewController stopLoadingAnimation];
} // fetchServiceComponents


#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (fetching || [serviceComponents count] == 0 ? 1 : [serviceComponents count]);
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
    
  // Configure the cell...
  if (fetching) {
    cell.textLabel.text = @"Loading, Please Wait...";
    cell.imageView.image = nil;
    return cell;
  }

  if (serviceIsREST) {
    cell.textLabel.text = [[serviceComponents objectAtIndex:indexPath.row] objectForKey:JSONEndpointLabelElement];
  } else {
    cell.textLabel.text = [[serviceComponents objectAtIndex:indexPath.row] objectForKey:JSONNameElement];
  }
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSURL *url = [NSURL URLWithString:[[serviceComponents objectAtIndex:indexPath.row] objectForKey:JSONResourceElement]];
  
  if ([[UIDevice currentDevice] isIPadDevice]) {
    [iPadDetailViewController showResourceInBioCatalogue:url];
  } else {
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:10];
    [(UIWebView *)iPhoneWebViewController.view loadRequest:request];
    [self.navigationController pushViewController:iPhoneWebViewController animated:YES];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [iPadDetailViewController release];
  [iPhoneWebViewController release];
  
  [myTableView release]; 
} // releaseIBOutlets

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
} // didReceiveMemoryWarning

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  [self releaseIBOutlets];
} // viewDidUnload

- (void)dealloc {
  [self releaseIBOutlets];
  
  [componentsProperties release];
  [serviceComponents release];
  [lastUsedPath release];

  [super dealloc];
} // dealloc


@end



@implementation WebViewController_iPhone

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation

@end

