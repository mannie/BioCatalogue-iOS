//
//  LatestServicesViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LatestServicesViewController_iPhone.h"


@implementation LatestServicesViewController_iPhone

@synthesize serviceCell, detailViewController, navigationController;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [latestServices release];
  latestServices = [[[JSON_Helper helper] latestServices:LatestServices] copy];

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
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (tableView == self.tableView) {
    return [latestServices count];
  } else {
    return [searchResults count];
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
/*
    [[NSBundle mainBundle] loadNibNamed:@"ServiceCell_iPhone" owner:self options:nil];
    cell = serviceCell;
 */
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  id service;
  if (tableView == self.tableView) {
    service = [latestServices objectAtIndex:indexPath.row];  
  } else {
    service = [searchResults objectAtIndex:indexPath.row];
  }

  cell.textLabel.text = [service objectForKey:JSONNameElement];
  cell.detailTextLabel.text = [[service objectForKey:JSONTechnologyTypesElement] lastObject];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

/*
  UILabel *nameLabel = (UILabel *)[cell viewWithTag:ServiceNameTag];
  nameLabel.text = [service objectForKey:JSONName];
  
  UILabel *descriptionLabel = (UILabel *)[cell viewWithTag:ServiceDescriptionTag];
  NSString *description = [NSString stringWithFormat:@"%@", [service objectForKey:JSONDescription]];
  if ([description isEqualToString:JSONNull]) {
    descriptionLabel.text = @"-";
  } else {
    descriptionLabel.text = [service objectForKey:JSONDescription];
  }
*/
  NSURL *imageURL = [NSURL URLWithString:
                     [[service objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONSmallSymbolElement]];
  cell.imageView.image = [UIImage imageNamed:[[imageURL lastPathComponent] stringByDeletingPathExtension]];

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
  [detailViewController loadView];
  
  id updateProperties;
  if (tableView == self.tableView) {
    updateProperties = [latestServices objectAtIndex:indexPath.row];
  } else {
    updateProperties = [searchResults objectAtIndex:indexPath.row];
  }
  
  updateDetailViewControllerThread = [[NSThread alloc] initWithTarget:detailViewController
                                                             selector:@selector(updateWithProperties:)
                                                               object:updateProperties];
  [updateDetailViewControllerThread start];
  [updateDetailViewControllerThread release];
  
  // Pass the selected object to the new view controller.
  [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark -
#pragma mark Search bar delegate

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSDictionary *results = [[BioCatalogueClient client] performSearch:searchBar.text
                                                           withScope:ServicesSearchScope
                                                  withRepresentation:JSONFormat];

  [searchResults release];
  if (results) {
    searchResults = [[results objectForKey:JSONResultsElement] copy];
  } else {
    searchResults = [NSArray array];
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
  [searchResults release];
  [latestServices release];
  [serviceCell release];
  
  [detailViewController release];
  
  [updateDetailViewControllerThread release];
  
  [super dealloc];
}


@end

