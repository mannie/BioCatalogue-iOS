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

@synthesize detailViewController;


#pragma mark -
#pragma mark Private Helpers

-(void) performServiceFetch {  
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  fetching = YES;
  [services release];
  
  if (currentPage < 1) {
    currentPage = 1;
  }
  
  if (lastPage < 1) {
    NSDictionary *servicesDocument = [[JSON_Helper helper] documentAtPath:@"services"];
    services = [[servicesDocument objectForKey:JSONResultsElement] copy];
    lastPage = [[servicesDocument objectForKey:JSONPagesElement] intValue];
    
    currentPageLabel.hidden = NO;
  } else {
    services = [[[JSON_Helper helper] services:ServicesPerPage page:currentPage] copy];
  }
  
  services = [[[JSON_Helper helper] services:ServicesPerPage page:currentPage] copy];
  currentPageLabel.text = [NSString stringWithFormat:@"Page %i of %i", currentPage, lastPage];
  
  initializing = NO;
  fetching = NO;
  [[self tableView] reloadData];
  
  [detailViewController stopAnimatingActivityIndicator];
  
  [autoreleasePool drain];
} // performServiceFetch

-(void) startThreadToFetchServicesForCurrentPage {
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
} // startThreadToFetchServicesForCurrentPage


#pragma mark -
#pragma mark IBActions

-(IBAction) loadServicesOnNextPage:(id)sender {
  if (!fetching) {
    if ([services count] > 0) {
      currentPage++;
    }
    [self startThreadToFetchServicesForCurrentPage];
  }
} // loadServicesOnNextPage

-(IBAction) loadServicesOnPreviousPage:(id)sender {
  if (!fetching) {
    if (currentPage > 1) {
      currentPage--;
    }
    [self startThreadToFetchServicesForCurrentPage];
  }
} // loadServicesOnPreviousPage


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.clearsSelectionOnViewWillAppear = NO;
  self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

  initializing = YES;
  
  currentPageLabel.text = @"Loading, Please Wait...";
  
  currentPage = 0;
  lastPage = 0;
  
  [self startThreadToFetchServicesForCurrentPage];   
} // viewDidLoad

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (initializing) {
    return 0;
  } else {
    return 3;
  }
} // numberOfSectionsInTableView


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (!initializing && section == MainSection) {
    return [services count];
  } else {
    return 1;
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
  if (indexPath.section == MainSection) {
    [detailViewController startAnimatingActivityIndicator];
    
    NSDictionary *listing = [services objectAtIndex:indexPath.row];
    detailViewController.loadingText = [listing objectForKey:JSONNameElement];
    [detailViewController setDescription:[listing objectForKey:JSONDescriptionElement]];

    // FIXME: threading issues
    [detailViewController updateWithPropertiesForServicesScope:listing];
//    [NSThread detachNewThreadSelector:@selector(updateWithPropertiesForServicesScope:)
//                             toTarget:detailViewController 
//                           withObject:listing];
  } else {
    if (indexPath.section == PreviousPageButtonSection && currentPage != 1) {
      [detailViewController startAnimatingActivityIndicator];
      [self loadServicesOnPreviousPage:self];
    } 
    
    if (indexPath.section == NextPageButtonSection && currentPage != lastPage) {
      [detailViewController startAnimatingActivityIndicator];
      [self loadServicesOnNextPage:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [currentPageLabel release];
  [detailViewController release];
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

