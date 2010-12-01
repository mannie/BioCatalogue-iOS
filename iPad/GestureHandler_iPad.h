//
//  GestureHandler_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIDevice+Helper.h"


@interface GestureHandler_iPad : NSObject {  
  NSMutableDictionary *initialCenterPositionsInLandscape;
  NSMutableDictionary *initialCenterPositionsInPortrait;
    
  IBOutlet UIView *defaultView;
  IBOutlet UIView *serviceDetailView;
  
  IBOutlet UIView *userDetailView;  
  IBOutlet UIView *userDetailIDCardView;

  IBOutlet UIView *providerDetailView;  
  IBOutlet UIView *providerDetailIDCardView;
  
  IBOutlet UIView *interactionDisablingLayer;
  IBOutlet UIView *auxiliaryDetailPanel;
  
  BOOL auxiliaryDetailPanelIsExposed;
}

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer;

-(void) rolloutAuxiliaryDetailPanel:(UISwipeGestureRecognizer *)recognizer;

-(void) enableInteractionDisablingLayer;
-(void) disableInteractionDisablingLayer:(UITapGestureRecognizer *)recognizer;

@end
