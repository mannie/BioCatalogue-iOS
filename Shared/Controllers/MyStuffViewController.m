//
//  MyStuffViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 09/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//

#import "AppImports.h"


@implementation MyStuffViewController

@synthesize iPadDetailViewController, iPhoneDetailViewController;


typedef enum { UserFavourites, UserSubmissions, UserResponsibilities } MyStuffCategory;


#pragma mark -
#pragma mark Data Source Helpers

-(void) reloadDataInMainThread {
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void) stopAnimatingActivityIndicator {
  if (activeFetchThreadsForUserSubmissions == 0) {
    [activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
  }
} // stopAnimatingActivityIndicator

-(void) loadUserSubmissionsForNextPage {
  if (lastLoadedPageOfUserSubmissions == lastPageOfUserSubmissions) {
    activeFetchThreadsForUserSubmissions--;
    [self stopAnimatingActivityIndicator];
    return;
  }
  
  dispatch_async(dispatch_queue_create("Load next page", NULL), ^{
    lastLoadedPageOfUserSubmissions++;
    int pageToLoad = lastLoadedPageOfUserSubmissions; // use local var to reduce contention when loading in multiple threads
    
    NSUInteger currentUserID = [[[BioCatalogueResourceManager catalogueUser] uniqueID] intValue];
    NSDictionary *document = [[BioCatalogueClient services:ItemsPerPage page:pageToLoad submittingUserID:currentUserID] retain];
    if (document) {
      [userSubmissions addObjectsFromArray:[document objectForKey:JSONResultsElement]];
      
      for (NSDictionary *serviceProperties in userSubmissions) {
        NSUInteger uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
        Service *service = [BioCatalogueResourceManager serviceWithUniqueID:uniqueID];
        [[BioCatalogueResourceManager catalogueUser] addServicesSubmittedObject:service];
      }
      [BioCatalogueResourceManager commitChanges];
      
      lastPageOfUserSubmissions = [[document objectForKey:JSONPagesElement] intValue];
      
      [document release];
    }
    
    [UpdateCenter checkForServiceUpdates:userSubmissions
                      performingSelector:@selector(reloadDataInMainThread)
                                onTarget:self];
    activeFetchThreadsForUserSubmissions--;
    
    [self stopAnimatingActivityIndicator];    
  });
} // loadUserSubmissionsForNextPage

-(void) loadUserFavourites {
  dispatch_async(dispatch_queue_create("Load user favourites", NULL), ^{
    NSUInteger currentUserID = [[[BioCatalogueResourceManager catalogueUser] uniqueID] intValue];

    NSDictionary *document = [[BioCatalogueClient servicesForFavouritingUserID:currentUserID] retain];
    if (document) {
      [userFavourites release];
      userFavourites = [[document objectForKey:JSONResultsElement] retain];
      
      int count = [userFavourites count];
      NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:count];
      for (int i = 0; i < count; i++) {
        [sortedArray insertObject:[userFavourites objectAtIndex:count-1-i] atIndex:i];
      }
      [userFavourites autorelease];
      userFavourites = [[NSArray arrayWithArray:sortedArray] retain];
      
      for (NSDictionary *serviceProperties in userFavourites) {
        NSUInteger uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
        Service *service = [BioCatalogueResourceManager serviceWithUniqueID:uniqueID];
        [[BioCatalogueResourceManager catalogueUser] addServicesFavouritedObject:service];
      }
      [BioCatalogueResourceManager commitChanges];
            
      [document release];
    }
    
    [UpdateCenter checkForServiceUpdates:userFavourites
                      performingSelector:@selector(reloadDataInMainThread)
                                onTarget:self];
    
    [self stopAnimatingActivityIndicator];    
  });  
} // loadUserFavourites

-(void) loadUserResponsibilities {
  dispatch_async(dispatch_queue_create("Load user responsibilities", NULL), ^{
    NSUInteger currentUserID = [[[BioCatalogueResourceManager catalogueUser] uniqueID] intValue];
    
    NSDictionary *document = [[BioCatalogueClient servicesForResponsibleUserID:currentUserID] retain];
    if (document) {
      [userResponsibilities release];
      userResponsibilities = [[document objectForKey:JSONResultsElement] retain];

      for (NSDictionary *serviceProperties in userResponsibilities) {
        NSUInteger uniqueID = [[[serviceProperties objectForKey:JSONResourceElement] lastPathComponent] intValue];
        Service *service = [BioCatalogueResourceManager serviceWithUniqueID:uniqueID];
        [[BioCatalogueResourceManager catalogueUser] addServicesResponsibleForObject:service];
      }
      
      [document release];
    }
    [BioCatalogueResourceManager commitChanges];

    [UpdateCenter checkForServiceUpdates:userResponsibilities
                      performingSelector:@selector(reloadDataInMainThread)
                                onTarget:self];
    
    [self stopAnimatingActivityIndicator];    
  });  
} // loadUserResponsibilities

-(void) refreshTableViewDataSource {
  [activityIndicator startAnimating];
  
  [userSubmissions release];
  userSubmissions = [[NSMutableArray alloc] init];
  
  [userFavourites release];
  userFavourites = [[NSArray alloc] init];
  
  [userResponsibilities release];
  userResponsibilities = [[NSArray alloc] init];
  
  [[self tableView] performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  
  // UserFavourites
  [self loadUserFavourites];
  
  // UserResponsibilities
  [self loadUserResponsibilities];
  
  // UserSubmissions
  lastLoadedPageOfUserSubmissions = 0;
  lastPageOfUserSubmissions = 1;
  
  activeFetchThreadsForUserSubmissions++;
  [self loadUserSubmissionsForNextPage];
} // refreshTableViewDataSource


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [UIContentController customiseTableView:[self tableView]];
  [self refreshTableViewDataSource];
} // viewDidLoad

-(void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  if (![BioCatalogueClient userIsAuthenticated]) {
    [[self navigationController] popViewControllerAnimated:YES];
  }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
} // shouldAutorotateToInterfaceOrientation


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case UserFavourites: return [userFavourites count];
    case UserSubmissions: return [userSubmissions count];
    case UserResponsibilities: return [userResponsibilities count];
    default: return 0;
  }
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  switch (section) {
    case UserFavourites: return @"My Favourite Services";
    case UserSubmissions: return @"Services I Submitted";
    case UserResponsibilities: return @"Services I Am Responsible For";
    default: return nil;
  }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:CustomCellXIB owner:self options:nil] lastObject];
  }
  
  // Configure the cell...
  /*
  if ([indexPath section] == UserSubmissions && lastLoadedPage < lastPage && [indexPath row] >= AutoLoadTrigger) {
    // indexPath is in the last section
    @try {
      if (activeFetchThreads < 3) {
        activeFetchThreads++;
        [activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
        [self loadUserSubmissionsForNextPage];
      }
    } @catch (NSException * e) {
      [e log];
    }    
  }
  */

  switch ([indexPath section]) {
    case UserSubmissions:
      [UIContentController populateTableViewCell:cell 
                                      withObject:[userSubmissions objectAtIndex:[indexPath row]]
                                      givenScope:ServiceResourceScope];
      break;
    case UserFavourites:
      [UIContentController populateTableViewCell:cell 
                                      withObject:[userFavourites objectAtIndex:[indexPath row]]
                                      givenScope:ServiceResourceScope];      
      break;
    case UserResponsibilities:
      [UIContentController populateTableViewCell:cell 
                                      withObject:[userResponsibilities objectAtIndex:[indexPath row]]
                                      givenScope:ServiceResourceScope];
      break;
  }
  
  return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *itemsInSection;
  switch ([indexPath section]) {
    case UserSubmissions: itemsInSection = userSubmissions; break;
    case UserFavourites: itemsInSection = userFavourites; break;
    case UserResponsibilities: itemsInSection = userResponsibilities; break;
  }

  if ([[UIDevice currentDevice] isIPadDevice]) {
    if ([iPadDetailViewController isCurrentlyBusy] && lastSelectedIndexIPad) {
      [tableView selectRowAtIndexPath:lastSelectedIndexIPad animated:YES 
                       scrollPosition:UITableViewScrollPositionMiddle];
      return;
    }
    
    [iPadDetailViewController startLoadingAnimation];
    
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPadDetailViewController updateWithPropertiesForServicesScope:[itemsInSection objectAtIndex:[indexPath row]]];
    });
    
    [lastSelectedIndexIPad release];
    lastSelectedIndexIPad = [indexPath retain];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  } else {
    [iPhoneDetailViewController makeShowProvidersButtonVisible:YES];
    dispatch_async(dispatch_queue_create("Update detail view controller", NULL), ^{
      [iPhoneDetailViewController updateWithProperties:[itemsInSection objectAtIndex:[indexPath row]]];
    });
    [[self navigationController] pushViewController:iPhoneDetailViewController animated:YES];
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
  } // if else ipad
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) viewDidUnload {
  [super viewDidUnload];
}
-(void) releaseIBOutlets {
  [activityIndicator release];
}

- (void)dealloc {
  [lastSelectedIndexIPad release];
  
  [userSubmissions release];
  [userFavourites release];
  [userResponsibilities release];
  
  [self releaseIBOutlets];
  
  [super dealloc];
}


@end

