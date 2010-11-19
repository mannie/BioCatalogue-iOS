//
//  GestureHandler_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GestureHandler_iPad : NSObject {  
  NSMutableDictionary *initialCenterPositionsInLandscape;
  NSMutableDictionary *initialCenterPositionsInPortrait;
  
  IBOutlet UITableView *containerTableView;
  
  IBOutlet UIView *defaultView;
  IBOutlet UIView *serviceDetailView;
  
  IBOutlet UIView *userDetailView;  
  IBOutlet UIView *userDetailIDCardView;

  IBOutlet UIView *providerDetailView;  
  IBOutlet UIView *providerDetailIDCardView;
  
  BOOL auxiliaryDetailPanelExposed;
}

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer;
-(void) rolloutAuxiliaryDetailPanel:(UISwipeGestureRecognizer *)recognizer;

@end
