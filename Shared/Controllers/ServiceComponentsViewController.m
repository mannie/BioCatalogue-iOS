//
//  ServiceComponentsViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation ServiceComponentsViewController

@synthesize detailViewController, iPhoneWebViewController;


#pragma mark -
#pragma mark Helpers

-(void) updateWithServiceComponentsForPath:(NSString *)path {
  if ([currentPath isEqualToString:path]) return;

  currentlyFetchingComponents = YES;
  
  [currentPath release];
  currentPath = [path retain];
  
  dispatch_async(dispatch_queue_create("Load provider services", NULL), ^{
    [serviceComponentsInfo release];
    serviceComponentsInfo = [[NSDictionary dictionary] retain];
    
    [serviceComponents release];
    serviceComponents = [[NSArray array] retain];
    
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
    
    [serviceComponentsInfo release];
    serviceComponentsInfo = [[BioCatalogueClient documentAtPath:path] retain];
              
    serviceIsREST = [[path lastPathComponent] isEqualToString:@"methods"];

    [serviceComponents release];
    if (serviceIsREST) {
      serviceComponents = [[serviceComponentsInfo objectForKey:JSONMethodsElement] retain];
    } else {
      serviceComponents = [[serviceComponentsInfo objectForKey:JSONOperationsElement] retain];
    }  

    currentlyFetchingComponents = NO;
    [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
});
} // updateWithServiceComponentsForPath


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];

  [UIContentController customiseTableView:[self tableView]];
} // viewDidLoad

-(void) viewWillAppear:(BOOL)animated {
  [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];

  if (!viewHasBeenUpdated && currentPath) [self updateWithServiceComponentsForPath:currentPath];
  [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated {
  viewHasBeenUpdated = NO;
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (currentlyFetchingComponents) {
    return 0;
  } else if ([serviceComponents count] == 0) {
    return 1;
  } else {
    return [serviceComponents count];
  }
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier] autorelease];
  }

  if ([serviceComponents count] == 0) {
    [[cell textLabel] setText:nil];
    [[cell imageView] setImage:nil];

    if (!currentlyFetchingComponents) {
      [[cell detailTextLabel] setText:[NSString stringWithFormat:@"No %@", (serviceIsREST ? RESTComponentsText : SOAPComponentsText)]];
    } 
  
    return cell;
  }
  
  // Configure the cell...
  if (serviceIsREST) {
    [[cell textLabel] setText:[[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONEndpointLabelElement]];
    NSString *name = [NSString stringWithFormat:@"%@", [[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONNameElement]];
    [[cell detailTextLabel] setText:([name isValidJSONValue] ? name : nil)];
  } else {
    [[cell textLabel] setText:[[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONNameElement]];
    [[cell detailTextLabel] setText:nil];
  }
  
  [[cell imageView] setImage:[UIImage imageNamed:CogIcon]];
  
  [UIContentController customiseTableViewCell:cell];  
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
/*
  TODO: implement the ability to view component detail
 
  NSLog(@"%@", [serviceComponents objectAtIndex:indexPath.row]);
  if (serviceIsREST) {
    [detailViewController loadRESTMethodDetailView];
  } else {
    [detailViewController loadSOAPOperationDetailView];
  }

 
  [self.navigationController pushViewController:detailViewController animated:YES];
*/

  NSURL *url = [NSURL URLWithString:[[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONResourceElement]];  
  NSURLRequest *request = [NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                       timeoutInterval:APIRequestTimeout];
  [(UIWebView *)[iPhoneWebViewController view] loadRequest:request];
  [[self navigationController] pushViewController:iPhoneWebViewController animated:YES];
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [activityIndicator release];
  
  [detailViewController release];
  
  [iPhoneWebViewController release];  
  [webBrowserController release];
} // releaseIBOutlets

- (void)dealloc {
  [self releaseIBOutlets];

  [serviceComponentsInfo release];
  [serviceComponents release];
  [currentPath release];

  [super dealloc];
} // dealloc


@end



@implementation WebViewController_iPhone

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation

@end

