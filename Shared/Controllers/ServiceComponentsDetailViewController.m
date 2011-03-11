//
//  ServiceComponentsDetailViewController.m
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppImports.h"


@implementation ServiceComponentsDetailViewController

typedef enum { InputParameters, InputRepresentations, OutputRepresentations } RESTSection;
typedef enum { Inputs, Outputs } SOAPSection;


#pragma mark -
#pragma mark Helpers

-(void) loadRESTMethodDetailView {
  if (![self view]) [self loadView];
  [uiContentController updateRESTEndpointUIElementsWithProperties:componentProperties];
  
  [self setView:restMethodDetailView];
  [self setTitle:[RESTComponentsText stringByReplacingCharactersInRange:NSMakeRange([RESTComponentsText length] - 1, 1) withString:@""]];
} // loadRESTMethodDetailView

-(void) loadSOAPOperationDetailView {
  if (![self view]) [self loadView];
  [uiContentController updateSOAPOperationUIElementsWithProperties:componentProperties];

  [self setView:soapOperationDetailView];
  [self setTitle:[SOAPComponentsText stringByReplacingCharactersInRange:NSMakeRange([SOAPComponentsText length] - 1, 1) withString:@""]];
} // loadSOAPOperationDetailView

-(void) updateWithComponentAtPath:(NSString *)path {
  if ([currentPath isEqualToString:path]) return;
  
  [currentPath release];
  currentPath = [path retain];
  
  dispatch_async(dispatch_queue_create("Load component", NULL), ^{
    [componentProperties release];
    componentProperties = [[NSDictionary dictionary] retain];

    [componentProperties release];
    componentProperties = [[BioCatalogueClient documentAtPath:path] retain];
    
    serviceIsREST = [[[path stringByDeletingLastPathComponent] lastPathComponent] isEqualToString:@"rest_methods"];

    if (serviceIsREST) {
      [self performSelectorOnMainThread:@selector(loadRESTMethodDetailView) withObject:nil waitUntilDone:NO];
    } else {
      [self performSelectorOnMainThread:@selector(loadSOAPOperationDetailView) withObject:nil waitUntilDone:NO];
    }

    viewHasBeenUpdated = YES;
  });
} // updateWithComponentAtPath


#pragma mark -
#pragma mark IBActions

-(IBAction) showInputsAndOutputs:(id)sender {
  [myTableView reloadData];
  
  RotatableEmptyTableViewController *tableViewController = [[RotatableEmptyTableViewController alloc] init];
  [tableViewController setView:myTableView];
  
  [[self navigationController] pushViewController:tableViewController animated:YES];
  
  [tableViewController release];
} // showInputsAndOutputs


#pragma mark -
#pragma mark View lifecycle

-(void) viewDidLoad {
  [super viewDidLoad];

  [UIContentController customiseTableView:myTableView];
}

-(void) viewWillAppear:(BOOL)animated {
  if (!viewHasBeenUpdated && currentPath) [self updateWithComponentAtPath:currentPath];
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
#pragma mark UITableViewDataSource

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  if (serviceIsREST) {
    return 3;
  } else {
    return 2;
  }
} // numberOfSectionsInTableView

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (serviceIsREST) {
    switch (section) {
      case InputParameters: return @"REST Input Parameters";
      case InputRepresentations: return @"REST Input Representations";
      default: return @"REST Output Representations";
    }
  } else {
    switch (section) {
      case Inputs: return @"SOAP Inputs";
      default: return @"SOAP Outputs";
    }
  }  
} // tableView:titleForHeaderInSection

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  int count;
  if (serviceIsREST) {
    switch (section) {
      case InputParameters: count = [[[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONParametersElement] count]; break;
      case InputRepresentations: count = [[[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONRepresentationElement] count]; break;
      default: count = [[[componentProperties objectForKey:JSONOutputsElement] objectForKey:JSONRepresentationElement] count]; break;
    }
  } else {
    switch (section) {
      case Inputs: count = [[componentProperties objectForKey:JSONInputsElement] count]; break;
      default: count = [[componentProperties objectForKey:JSONOutputsElement] count]; break;
    }
  }
  
  return (count == 0 ? 1 : count);
} // tableView:numberOfRowsInSection

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  id collection;
  if (serviceIsREST) {
    switch ([indexPath section]) {
      case InputParameters: collection = [[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONParametersElement]; break;
      case InputRepresentations: collection = [[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONRepresentationElement]; break;
      default: collection = [[componentProperties objectForKey:JSONOutputsElement] objectForKey:JSONRepresentationElement]; break;
    }
  } else {
    switch ([indexPath section]) {
      case Inputs: collection = [componentProperties objectForKey:JSONInputsElement]; break;
      default: collection = [componentProperties objectForKey:JSONOutputsElement]; break;
    }
  }
  
  [UIContentController customiseTableViewCell:cell];

  if ([collection count] == 0) {
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"No %@", [self tableView:tableView titleForHeaderInSection:[indexPath section]]]];
    [[cell textLabel] setText:nil];
    [[cell imageView] setImage:nil];    
    
    return cell;
  }
  
  id item = [collection objectAtIndex:[indexPath row]];

  if (serviceIsREST && [indexPath section] != InputParameters) {
    [[cell textLabel] setText:[item objectForKey:JSONContentTypeElement]];
  } else {
    [[cell textLabel] setText:[item objectForKey:JSONNameElement]];
  }
  [[cell imageView] setImage:[UIImage imageNamed:DotIcon]];
  [[cell detailTextLabel] setText:nil];
  
  return cell;
} // tableView:cellForRowAtIndexPath


#pragma mark -
#pragma mark UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  id collection;
  if (serviceIsREST) {
    switch ([indexPath section]) {
      case InputParameters: collection = [[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONParametersElement]; break;
      case InputRepresentations: collection = [[componentProperties objectForKey:JSONInputsElement] objectForKey:JSONRepresentationElement]; break;
      default: collection = [[componentProperties objectForKey:JSONOutputsElement] objectForKey:JSONRepresentationElement]; break;
    }
  } else {
    switch ([indexPath section]) {
      case Inputs: collection = [componentProperties objectForKey:JSONInputsElement]; break;
      default: collection = [componentProperties objectForKey:JSONOutputsElement]; break;
    }
  }

  if ([collection count] != 0) {
    id item = [collection objectAtIndex:[indexPath row]];
    
    NSString *description = [NSString stringWithFormat:@"%@", [item objectForKey:JSONDescriptionElement]];
    description = ([description isValidJSONValue] ? description : NoInformationText);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Info" message:description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
  
  [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
} // tableView:didSelectRowAtIndexPath


#pragma mark -
#pragma mark Memory management

-(void) releaseIBOutlets {
  [myTableView release];
  
  [restMethodDetailView release];
  [soapOperationDetailView release];
  
  [uiContentController release];
} 

- (void)dealloc {
  [self releaseIBOutlets];
  
  [currentPath release];
  
  [super dealloc];
}

@end


@implementation RotatableEmptyTableViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
} // shouldAutorotateToInterfaceOrientation

@end

