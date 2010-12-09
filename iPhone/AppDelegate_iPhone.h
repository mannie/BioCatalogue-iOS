//
//  AppDelegate_iPhone.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

#import "AppConstants.h"


@interface AppDelegate_iPhone : AppDelegate_Shared {
  UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

