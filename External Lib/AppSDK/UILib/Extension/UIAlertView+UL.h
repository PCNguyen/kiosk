//
//  UIAlertView+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewActionBlock)(NSInteger buttonIndex);
typedef void(^UIAlertViewCancelBlock)();

@interface UIAlertView (UL)

#pragma mark - Status Check

+ (instancetype)ul_currentVisibleAlert;

#pragma mark - Convenient

+ (instancetype)ul_showInfoAlertViewWithMessage:(NSString *)message;

+ (instancetype)ul_showWarningAlertViewWithMessage:(NSString *)message;

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message;

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock;

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle;

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock;

#pragma mark - Core

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  otherTitles:(NSArray *)buttonTitles
							  actionBlock:(UIAlertViewActionBlock)actionBlock
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock;

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  otherTitles:(NSArray *)buttonTitles
									style:(UIAlertViewStyle)style
							  actionBlock:(UIAlertViewActionBlock)actionBlock
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock;

+ (instancetype)ul_alertViewWithTitle:(NSString *)title
							  message:(NSString *)message
						  cancelTitle:(NSString *)cancelTitle
						  otherTitles:(NSArray *)otherTitles
						  actionBlock:(UIAlertViewActionBlock)actionBlock
						  cancelBlock:(UIAlertViewCancelBlock)cancelBlock;

@end
