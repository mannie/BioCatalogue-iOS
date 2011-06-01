//
//  ServiceComponentsViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 21/11/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//

#import "AppImports.h"


@implementation ServiceComponentsViewController

@synthesize detailViewController;


#pragma mark -
#pragma mark Helpers

-(void) updateWithServiceComponentsForPath:(NSString *)path {
  if ([currentPath isEqualToString:path]) return;

  currentlyFetchingComponents = YES;
  
  [currentPath release];
  currentPath = [path retain];
  
  dispatch_async(dispatch_queue_create("Load components", NULL), ^{
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
      [self performSelectorOnMainThread:@selector(setTitle:) withObject:RESTComponentsText waitUntilDone:NO];
    } else {
      serviceComponents = [[serviceComponentsInfo objectForKey:JSONOperationsElement] retain];
      [self performSelectorOnMainThread:@selector(setTitle:) withObject:SOAPComponentsText waitUntilDone:NO];
    }

    currentlyFetchingComponents = NO;
    viewHasBeenUpdated = YES;
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

  [UIContentController customiseTableViewCell:cell];  

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
    NSString *endpointLabel = [[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONEndpointLabelElement];
    NSString *name = [NSString stringWithFormat:@"%@", [[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONNameElement]];

    if ([name isValidJSONValue]) {
      [[cell textLabel] setText:name];
      [[cell detailTextLabel] setText:endpointLabel];
    } else {
      [[cell textLabel] setText:endpointLabel];
      [[cell detailTextLabel] setText:nil];
    }
  } else {
    [[cell textLabel] setText:[[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONNameElement]];
    [[cell detailTextLabel] setText:nil];
  }
  
  [[cell imageView] setImage:[UIImage imageNamed:CogIcon]];
    
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([serviceComponents count] != 0) {
    NSURL *url = [NSURL URLWithString:[[serviceComponents objectAtIndex:[indexPath row]] objectForKey:JSONResourceElement]];
    [detailViewController updateWithComponentAtPath:[url path]];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];    
  }

  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [activityIndicator release];
  
  [detailViewController release];
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

