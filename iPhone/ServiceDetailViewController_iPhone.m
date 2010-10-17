//
//  ServiceDetailViewController_iPhone.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 08/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServiceDetailViewController_iPhone.h"


@implementation ServiceDetailViewController_iPhone

@synthesize name, userDetailViewController;


-(void) updateWithProperties:(NSDictionary *)properties {
  NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
  
  self.view.userInteractionEnabled = NO;
  
  serviceListingProperties = [properties copy];

  NSURL *resourceURL = [NSURL URLWithString:[properties objectForKey:JSONResourceElement]];  
  serviceProperties = [[[JSON_Helper helper] documentAtPath:[resourceURL path]] copy];
//  serviceMonitoringProperties = [JSON_Helper documentAtPath:[[resourceURL path] stringByAppendingPathComponent:@"monitoring"]];

  NSURL *submitterURL = [NSURL URLWithString:[properties objectForKey:JSONSubmitterElement]];
  submitterProperties = [[[JSON_Helper helper] documentAtPath:[submitterURL path]] copy];
  
  name.text = [serviceListingProperties objectForKey:JSONNameElement];
  
  [[self tableView] reloadData];
  self.view.userInteractionEnabled = YES;
  
  [autoreleasePool drain];
} // updateWithProperties


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
 [super viewDidLoad];
 
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
  return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 2) {
    return 3;
  } else {
    return 1;
  }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSString *value;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  if (indexPath.section == 0) {
    cell.textLabel.text = @"About";
    value = [NSString stringWithFormat:@"%@", [serviceListingProperties objectForKey:JSONDescriptionElement]];
    if ([value isEqualToString:JSONNull]) {
      cell.detailTextLabel.text = @"No description";
      cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
      cell.detailTextLabel.text = value;
    }
  } else if (indexPath.section == 1) {
    cell.textLabel.text = @"Monitoring";
    cell.detailTextLabel.text = [[serviceListingProperties objectForKey:JSONLatestMonitoringStatusElement] objectForKey:JSONLabelElement];
  } else {
    if (indexPath.row == 0) {
      cell.textLabel.text = @"Provider";
      
      id provider = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject]
                      objectForKey:JSONProviderElement] objectForKey:JSONNameElement];
      cell.detailTextLabel.text = provider;
    } else if (indexPath.row == 1) {
      cell.textLabel.text = @"Submitter";
      cell.detailTextLabel.text = [submitterProperties objectForKey:JSONNameElement];
    } else {
      cell.textLabel.text = @"Location";
      id country = [[[[serviceProperties objectForKey:JSONDeploymentsElement] lastObject] 
                     objectForKey:JSONLocationElement] objectForKey:JSONCountryElement];

      if ([[NSString stringWithFormat:@"%@", country] isEqualToString:JSONNull]) {
        cell.detailTextLabel.text = @"Unknown";
      } else {
        cell.detailTextLabel.text = country;
      }

      cell.accessoryType = UITableViewCellAccessoryNone;
    }
  }
    
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
  if (indexPath.section == 0) {
    // descriptions
  } else if (indexPath.section == 1) {
    // monitoring
  } else {
    if (indexPath.row == 0) {
      // provider
    } else if (indexPath.row == 1) {
      // submitting user
      [userDetailViewController loadView];
      [userDetailViewController updateWithProperties:submitterProperties];
      [self.navigationController pushViewController:userDetailViewController animated:YES];
    } else {
      // location
    }
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
  [userDetailViewController release];
  
  [name release];
  
  [serviceListingProperties release];
  [serviceProperties release];
  [serviceMonitoringProperties release];
  [submitterProperties release];
  
  [super dealloc];
}


@end

