//
//  UIViewController+Alert.h
//  Reputation
//
//  Created by PC Nguyen on 10/30/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPAlertController.h"

@interface UIViewController (Alert)

- (void)rp_showInfoAlertViewWithMessage:(NSString *)message;

- (void)rp_showWarningAlertViewWithMessage:(NSString *)message;

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message;

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelBlock:(void (^)())cancelBlock;

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelTitle:(NSString *)cancelTitle;

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelTitle:(NSString *)cancelTitle
					  cancelBlock:(void (^)())cancelBlock;
@end
