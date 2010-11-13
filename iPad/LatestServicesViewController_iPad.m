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
#pragma mark Helpers

-(void) performServiceFetch {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
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
  [[self tableView] reloadData];
  
  [autoreleasePool drain];
}


#pragma mark -
#pragma mark IBActions

-(IBAction) loadServicesOnNextPage:(id)sender {
  if ([services count] > 0) {
    currentPage++;
  }
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
}

-(IBAction) loadServicesOnPreviousPage:(id)sender {
  if (currentPage > 1) {
    currentPage--;
  }
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];
}


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
  
  [NSThread detachNewThreadSelector:@selector(performServiceFetch) toTarget:self withObject:nil];

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (initializing) {
    return 0;
  } else {
    return 3;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == MainSection) {
    return [services count];
  } else {
    return 1;
  }
}


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
    cell.detailTextLabel.text = [[service objectForKey:JSONTechnologyTypesElement] lastObject];
    
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


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == MainSection) {
    detailViewController.detailItem = [[services objectAtIndex:indexPath.row] objectForKey:JSONNameElement];
  } else {
    if (indexPath.section == PreviousPageButtonSection && currentPage != 1) {
      [self loadServicesOnPreviousPage:self];
    } 
    
    if (indexPath.section == NextPageButtonSection && currentPage != lastPage) {
      [self loadServicesOnNextPage:self];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [services release];
  [detailViewController release];
  
  [super dealloc];
}


@end

