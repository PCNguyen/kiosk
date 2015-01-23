//
//  RPKLayoutManager.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPKMenuViewController.h"

@interface RPKLayoutManager : NSObject

@property (nonatomic, strong) RPKMenuViewController *menuViewController;

+ (instancetype)sharedManager;

+ (UIViewController *)rootViewController;

- (void)loginViewControllerDidDismissed;

@end
