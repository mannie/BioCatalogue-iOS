//
//  FavouritesController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 12/12/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIContentController.h"
#import "BioCatalogueResourceManager.h"


@interface FavouritesController : UITableViewController {
  NSArray *favouritedServices;
  NSArray *submittedServices;
}

@end
