//
//  ServiceComponentsDetailViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 07/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ServiceComponentsDetailViewController : UIViewController {
  IBOutlet UIView *restMethodDetailView;
  IBOutlet UIView *soapOperationDetailView;
}

-(void) loadRESTMethodDetailView;
-(void) loadSOAPOperationDetailView;

@end
