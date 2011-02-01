//
//  BrowseByProviderViewController.h
//  BioMonitor
//
//  Created by Mannie Tagarira on 01/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshViewController.h"
#import "UIContentController.h"


@interface BrowseByProviderViewController : PullToRefreshViewController <PullToRefreshDataSource> {
  NSMutableDictionary *providers;
  
  NSUInteger lastLoadedPage;
}

@end
