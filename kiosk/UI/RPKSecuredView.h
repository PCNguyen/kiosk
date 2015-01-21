//
//  RPKSecuredView.h
//  Kiosk
//
//  Created by PC Nguyen on 1/20/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKView.h"

@interface RPKSecuredView : RPKView

/**
 *  Set the color for the lock background
 *	To create the padding between the lines and the lock
 *
 *  @param color the background color
 */
- (void)setLockBackgroundColor:(UIColor *)color;

/**
 *  Set the message to be displayed
 *
 *  @param securedMessage the secured message
 */
- (void)setSecuredMessage:(NSAttributedString *)securedMessage;

@end
