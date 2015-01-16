//
//  UIViewController+Alert.m
//  Reputation
//
//  Created by PC Nguyen on 10/30/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)rp_showInfoAlertViewWithMessage:(NSString *)message
{
	[self rp_showAlertViewWithTitle:@"Info" message:message cancelTitle:@"OK" cancelBlock:NULL];
}

- (void)rp_showWarningAlertViewWithMessage:(NSString *)message
{
	[self rp_showAlertViewWithTitle:@"Warning" message:message cancelTitle:@"OK" cancelBlock:NULL];
}

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
{
	[self rp_showAlertViewWithTitle:title message:message cancelTitle:@"OK" cancelBlock:NULL];
}

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelBlock:(void (^)())cancelBlock
{
	[self rp_showAlertViewWithTitle:title message:message cancelTitle:@"OK" cancelBlock:cancelBlock];
}

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelTitle:(NSString *)cancelTitle
{
	[self rp_showAlertViewWithTitle:title message:message cancelTitle:cancelTitle cancelBlock:NULL];
}

- (void)rp_showAlertViewWithTitle:(NSString *)title
						  message:(NSString *)message
					  cancelTitle:(NSString *)cancelTitle
					  cancelBlock:(void (^)())cancelBlock
{
	RPAlertController *alertController = [[RPAlertController alloc] initWithTitle:title message:message];
	[alertController addButtonTitle:cancelTitle style:AlertButtonStyleDefault action:^(RPAlertButton *button) {
		if (cancelBlock) {
			cancelBlock();
		}
	}];
	
	[self presentViewController:alertController animated:YES completion:NULL];
}

@end
