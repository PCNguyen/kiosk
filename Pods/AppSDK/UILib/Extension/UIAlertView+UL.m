//
//  UIAlertView+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIAlertView+UL.h"

static UIAlertViewActionBlock _alertActionBlock;
static UIAlertViewCancelBlock _alertCancelBlock;

@implementation UIAlertView (UL)

#pragma mark - Status Check

+ (instancetype)ul_currentVisibleAlert
{
	NSArray *windows = [[UIApplication sharedApplication] windows];
	
	NSInteger windowsCount = [windows count];
	
	if (windowsCount > 1) {
		for (UIWindow *window in windows) {
			UIView *checkedView = [[(UIWindow *)window subviews] firstObject];
			
			if ([checkedView isKindOfClass:[UIAlertView class]]) {
				return (UIAlertView *)checkedView;
			}
		}
	}
    
    return nil;
}

#pragma mark - Convenient

+ (instancetype)ul_showInfoAlertViewWithMessage:(NSString *)message
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:@"Info"
													 message:message
												 cancelTitle:@"Ok"
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:nil];
	
	return alertView;
}

+ (instancetype)ul_showWarningAlertViewWithMessage:(NSString *)message
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:@"Warning"
													 message:message
												 cancelTitle:@"Ok"
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:nil];
	
	return alertView;
}

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:title
													 message:message
												 cancelTitle:@"Cancel"
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:nil];
	
	return alertView;
}

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:title
													 message:message
												 cancelTitle:@"Cancel"
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:cancelBlock];
	
	return alertView;
	
}

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:title
													 message:message
												 cancelTitle:cancelTitle
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:nil];
	
	return alertView;
	
}

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock
{
	UIAlertView *alertView = [self ul_showAlertViewWithTitle:title
													 message:message
												 cancelTitle:cancelTitle
												 otherTitles:nil
												 actionBlock:nil
												 cancelBlock:cancelBlock];
	
	return alertView;
}

#pragma mark - Core

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  otherTitles:(NSArray *)buttonTitles
							  actionBlock:(UIAlertViewActionBlock)actionBlock
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock
{
	UIAlertView *alertView = [self ul_alertViewWithTitle:title
												 message:message
											 cancelTitle:cancelTitle
											 otherTitles:buttonTitles
											 actionBlock:actionBlock
											 cancelBlock:cancelBlock];
	[alertView show];
	
	return alertView;
}

+ (instancetype)ul_showAlertViewWithTitle:(NSString *)title
								  message:(NSString *)message
							  cancelTitle:(NSString *)cancelTitle
							  otherTitles:(NSArray *)buttonTitles
									style:(UIAlertViewStyle)style
							  actionBlock:(UIAlertViewActionBlock)actionBlock
							  cancelBlock:(UIAlertViewCancelBlock)cancelBlock
{
	UIAlertView *alertView = [self ul_alertViewWithTitle:title
												 message:message
											 cancelTitle:cancelTitle
											 otherTitles:buttonTitles
											 actionBlock:actionBlock
											 cancelBlock:cancelBlock];
	[alertView setAlertViewStyle:style];
	[alertView show];
	
	return alertView;
}

+ (instancetype)ul_alertViewWithTitle:(NSString *)title
							  message:(NSString *)message
						  cancelTitle:(NSString *)cancelTitle
						  otherTitles:(NSArray *)otherTitles
						  actionBlock:(UIAlertViewActionBlock)actionBlock
						  cancelBlock:(UIAlertViewCancelBlock)cancelBlock
{
	if (actionBlock) {
		_alertActionBlock = [actionBlock copy];
	}
	
	if (cancelBlock) {
		_alertCancelBlock = [cancelBlock copy];
	}
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
														message:message
													   delegate:[self self]
											  cancelButtonTitle:cancelTitle
											  otherButtonTitles:nil];
	
	for (NSString *buttonTitle in otherTitles) {
		[alertView addButtonWithTitle:buttonTitle];
	}
	
	return alertView;
}

#pragma mark - UIAlertView Delegate

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [alertView cancelButtonIndex]) {
		if (_alertCancelBlock) {
			_alertCancelBlock();
			_alertCancelBlock = NULL;
		}
	} else {
		if (_alertActionBlock) {
			_alertActionBlock(buttonIndex);
			_alertActionBlock = NULL;
		}
	}
}

@end
