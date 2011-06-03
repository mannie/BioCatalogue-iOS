//
//  ServiceComponentsDetailViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 University of Manchester. All rights reserved.
//


@interface ServiceComponentsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
  IBOutlet UIContentController *uiContentController;
  
  IBOutlet UIView *restMethodDetailView;
  IBOutlet UIView *soapOperationDetailView;

  IBOutlet UITableView *myTableView;
  
  NSString *currentPath;

  NSDictionary *componentProperties;
  
  BOOL serviceIsREST;
  BOOL viewHasBeenUpdated;
}

-(void) updateWithComponentAtPath:(NSString *)path;

-(IBAction) showInputsAndOutputs:(id)sender;

@end


@interface RotatableEmptyTableViewController : UITableViewController
@end

