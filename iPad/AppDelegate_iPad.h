//
//  AppDelegate_iPad.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 05/10/2010.
//  Copyright 2010 myGrid (University of Manchester). All rights reserved.
//


@interface AppDelegate_iPad : AppDelegate_Shared {
  UISplitViewController *splitViewController;
}

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@end

