//
//  UITextView+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 6/26/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UITextView+UL.h"

@implementation UITextView (UL)

- (void)ul_addDismissAccessoryWithText:(NSString *)buttonText barStyle:(UIBarStyle)barStyle
{
	UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:buttonText
																style:UIBarButtonItemStyleDone target:self
															   action:@selector(resignFirstResponder)];
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

@end
