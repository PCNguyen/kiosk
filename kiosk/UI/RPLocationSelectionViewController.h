//
//  RPLocationSelectionViewController.h
//  Reputation
//
//  Created by PC Nguyen on 6/9/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKViewController.h"
#import "RPLocationSelectionDataSource.h"

@class RPLocationSelectionViewController;

@protocol RPLocationSelectionViewControllerDelegate <NSObject>

@optional
- (void)locationSelectionViewController:(RPLocationSelectionViewController *)locationSelectionVC
						selectLocations:(NSArray *)locationIDs;
- (void)locationSelectionViewControllerDidDismiss;

@end

@interface RPLocationSelectionViewController : RPKViewController <ULViewDataBinding>

@property (nonatomic, weak) id<RPLocationSelectionViewControllerDelegate>delegate;

- (RPLocationSelectionDataSource *)selectionDataSource;

@end
