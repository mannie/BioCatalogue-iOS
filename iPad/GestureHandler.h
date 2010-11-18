//
//  GestureHandler.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 17/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GestureHandler : NSObject {  
  NSMutableDictionary *initialCenterPositionsInLandscape;
  NSMutableDictionary *initialCenterPositionsInPortrait;
}

-(void) panViewButResetPositionAfterwards:(UIPanGestureRecognizer *)recognizer;

@end
