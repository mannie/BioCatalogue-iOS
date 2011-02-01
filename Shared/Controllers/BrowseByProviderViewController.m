//
//  BrowseByProviderViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowseByProviderViewController.h"


@implementation BrowseByProviderViewController


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController setTableViewBackground:self.tableView];
  
  providers = [[NSMutableDictionary alloc] init];
//  [providers setObject:[BioCatalogueClient BLJSONProvidersForPage:1] forKey:[NSNumber numberWithInt:lastLoadedPage]];
  NSString *path = [NSString stringWithFormat:@"/service_providers?page=%i&per_page=%i", 1, ItemsPerPage];
  [providers setObject:[[BioCatalogueClient documentAtPath:path] objectForKey:JSONResultsElement]
                forKey:[NSNumber numberWithInt:lastLoadedPage]];

  lastLoadedPage++;
}


#pragma mark -
#pragma mark PullToRefreshDataSource

-(void) refreshTableViewDataSource {
  
}


#pragma mark -
#pragma mark Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return lastLoadedPage;
} // numberOfSectionsInTableView

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[providers objectForKey:[NSNumber numberWithInt:section]] count] + 1;
} // tableView:numberOfRowsInSection

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSArray *providersInSection = [providers objectForKey:[NSNumber numberWithInt:[indexPath section]]];
  
  if ([indexPath row] == [providersInSection count]) {
    cell.textLabel.text = LoadMoreItemsText;
    cell.detailTextLabel.text = nil;
  } else {
    cell.textLabel.text = [[providersInSection objectAtIndex:[indexPath row]] objectForKey:JSONNameElement];
    cell.detailTextLabel.text = [[providersInSection objectAtIndex:[indexPath row]] objectForKey:JSONResourceElement];
  }
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
  /*
   <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
   // ...
   // Pass the selected object to the new view controller.
   [self.navigationController pushViewController:detailViewController animated:YES];
   [detailViewController release];
   */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
  // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
  // For example: self.myOutlet = nil;
}


- (void)dealloc {
  [providers release];
  
  [super dealloc];
}


@end

