//
//  RPKExpirationViewController.h
//  Kiosk
//
//  Created by PC Nguyen on 1/22/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKViewController.h"

@class RPKExpirationViewController;

@protocol RPKExpirationViewControllerDelegate <NSObject>

@optional
- (void)expirationViewControllerTimeExpired:(RPKExpirationViewController *)expirationViewController;

@end

@interface RPKExpirationViewController : RPKViewController

@property (nonatomic, weak) id<RPKExpirationViewControllerDelegate>delegate;

- (void)startCountDown:(NSTimeInterval)timeRemain;
- (void)stopCountDown;

@end
