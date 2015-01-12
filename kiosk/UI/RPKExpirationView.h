//
//  RPKExpirationView.h
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPKView.h"

@class RPKExpirationView;

@protocol RPKExpirationViewDelegate <NSObject>

@optional
- (void)expirationViewTimeExpired:(RPKExpirationView *)expirationView;
- (void)expirationViewDidReceivedTap:(RPKExpirationView *)expirationView;

@end

@interface RPKExpirationView : RPKView

/**
 *  The time remaining in second
 */
@property (atomic, assign) __block NSTimeInterval timeRemaining;

/**
 *  delegate
 */
@property (nonatomic, weak) id<RPKExpirationViewDelegate>delegate;

/**
 *  Start timer counting down from the time remaining;
 */
- (void)startCountDown;

/**
 *  Stop counting down timer, 
 *	Possible to restart with startCountDown if timeRemaining not expired
 */
- (void)stopCountDown;

@end
