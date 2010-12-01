//
//  LatestServicesViewController_iPad.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 04/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LatestServicesViewController_iPad.h"
#import "DetailViewController_iPad.h"


@implementation LatestServicesViewController_iPad

@synthesize detailViewController, paginationDelegate;


#pragma mark -
#pragma mark Private Helpers

-(void) postFetchActions {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  currentPageLabel.hidden = NO;
  
  [services release];
  services = [[servicesData objectForKey:JSONResultsElement] retain];
  
  currentPageLabel.text = [NSString stringWithFormat:@"%i of %i", currentPage, lastPage];
    
  [[self tableView] reloadData];
  [detailViewController stopLoadingAnimation];
  
  [autoreleasePool drain];
} // postFetchActions

-(void) performServiceFetch {  
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  [detailViewController startLoadingAnimation];
  [paginationDelegate performServiceFetchForPage:&currentPage
                                        lastPage:&lastPage
                                        progress:&fetching
                                     resultsData:&servicesData
                              performingSelector:@selector(postFetchActions)
                                        onTarget:self];
  
  [autoreleasePool drain];
} // performServiceFetch


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
  
  currentPageLabel.text = @"Loading, Please Wait...";

  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (fetching) {
    return 1;
  } else {
    return 3;
  }
} // numberOfSectionsInTableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (fetching || [services count] == 0 || section != MainSection) {
    return 1;
  } else {
    return [services count];
  }
} // tableView:numberOfRowsInSection


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  if (fetching || [services count] == 0) {
    cell.textLabel.text = nil;
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.detailTextLabel.text = @"Loading, Please Wait...";
    
    return cell;
  }
  
  if (indexPath.section == MainSection) {
    id service = [services objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [service objectForKey:JSONNameElement];
    cell.detailTextLabel.text = [[BioCatalogueClient client] serviceType:service];
    
    NSURL *imageURL = [NSURL URLWithString:
                       [[service objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
    cell.imageView.image = [UIImage imageNamed:[[imageURL absoluteString] lastPathComponent]];
  } else {
    cell.detailTextLabel.text = nil;
    
    if (indexPath.section == PreviousPageButtonSection) {
      if (currentPage == 1) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Show Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Show Previous Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } else {
      if (currentPage == lastPage) {
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = @"Show Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      } else {
        cell.detailTextLabel.text = nil;
        cell.textLabel.text = @"Show Next Page...";
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
      }
    } // if else previous page button
  } // if else main section
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [detailViewController dismissAuxiliaryDetailPanel:self];
  
  if (lastSelection == indexPath && indexPath.section == MainSection) {
    return;
  }
  
  if (indexPath.section == MainSection) {
    NSDictionary *listing = [services objectAtIndex:indexPath.row];
    detailViewController.loadingText = [listing objectForKey:JSONNameElement];
    [detailViewController setDescription:[listing objectForKey:JSONDescriptionElement]];

    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:detailViewController
                                                                            selector:@selector(startLoadingAnimation)
                                                                              object:nil];
    [[NSOperationQueue mainQueue] addOperation:[operation autorelease]];
    
    operation = [[NSInvocationOperation alloc] initWithTarget:detailViewController
                                                     selector:@selector(updateWithPropertiesForServicesScope:) 
                                                       object:listing];
    [[NSOperationQueue mainQueue] addOperation:[operation autorelease]];
  } else {
    if (indexPath.section == PreviousPageButtonSection && currentPage != 1) {
      [detailViewController startLoadingAnimation];
      [NSThread detachNewThreadSelector:@selector(loadServicesOnPreviousPage) toTarget:paginationDelegate withObject:nil];
    } 
    
    if (indexPath.section == NextPageButtonSection && currentPage != lastPage) {
      [detailViewController startLoadingAnimation];
      [NSThread detachNewThreadSelector:@selector(loadServicesOnNextPage) toTarget:paginationDelegate withObject:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
  lastSelection = indexPath;
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [currentPageLabel release];
  [detailViewController release];
  [paginationDelegate release];
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
  [services release];
  [self releaseIBOutlets];
  
  [super dealloc];
} // dealloc


@end

