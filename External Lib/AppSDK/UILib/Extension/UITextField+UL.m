//
//  UITextField+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UITextField+UL.h"
#import "RPNotificationCenter.h"

NSString *const UITextFieldAccessoryDidDismiss = @"UITextFieldAccessoryDidDismiss";

@implementation UITextField (UL)

- (void)ul_addDismissAccessoryWithText:(NSString *)buttonText barStyle:(UIBarStyle)barStyle
{
	UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:buttonText
																style:UIBarButtonItemStyleDone target:self
															   action:@selector(ul_dismisAndNotified:)];
	UIBarButtonItem *flexspace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:self
																			   action:nil];
	NSArray *buttons = [NSArray arrayWithObjects:flexspace, dismiss, nil];
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	[toolbar setBarStyle:barStyle];
	[toolbar setItems:buttons];
	self.inputAccessoryView = toolbar;
	[toolbar sizeToFit];
}

- (void)ul_dismisAndNotified:(id)sender {
    [RPNotificationCenter postNotificationName:UITextFieldAccessoryDidDismiss userInfo:nil];
    [self resignFirstResponder];
}

@end
