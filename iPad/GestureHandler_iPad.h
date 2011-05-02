//
//  GestureHandler_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//


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
  
  IBOutlet UIToolbar *webBrowserToolbar;
  IBOutlet UIWebView *webBrowser;
}

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer;

-(void) rolloutAuxiliaryDetailPanel:(UISwipeGestureRecognizer *)recognizer;

-(void) enableInteractionDisablingLayer;
-(void) disableInteractionDisablingLayer:(UITapGestureRecognizer *)recognizer;

@end
