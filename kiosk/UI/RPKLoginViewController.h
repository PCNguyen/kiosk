//
//  RPKLoginViewController.h
//  Kiosk
//
//  Created by PC Nguyen on 1/19/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKViewController.h"

@class RPKLoginViewController;

@protocol RPKLoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidDismissed;

@end

@interface RPKLoginViewController : RPKViewController

@property (nonatomic, weak) id<RPKLoginViewControllerDelegate>delegate;

@end
