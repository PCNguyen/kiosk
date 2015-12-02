//
//  UIActionSheet+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIActionSheet+UL.h"

static OptionSelectedBlock _optionBlock;
static OptionCanceledBlock _cancelBlock;

@implementation UIActionSheet (UL)

+ (instancetype)ul_actionSheetWithTitle:(NSString *)title
					  cancelButtonTitle:(NSString *)cancelTitle
				 destructiveButtonTitle:(NSString *)destructiveTitle
					  otherButtonTitles:(NSArray *)titles
							   onCancel:(OptionCanceledBlock)cancelBlock
						 optionSelected:(OptionSelectedBlock)optionBlock {
	
	if (cancelBlock) {
		_cancelBlock = cancelBlock;
	}
	
	if (optionBlock) {
		_optionBlock = optionBlock;
	}
	
	UIActionSheet *sharedActionSheet = [[UIActionSheet alloc] initWithTitle:title
																   delegate:[self self]
														  cancelButtonTitle:nil
													 destructiveButtonTitle:destructiveTitle
														  otherButtonTitles:nil, nil];
	for (id buttonTitle in titles) {
		
		[sharedActionSheet addButtonWithTitle:buttonTitle];
		
	}
	
	[sharedActionSheet addButtonWithTitle:cancelTitle];
	[sharedActionSheet setCancelButtonIndex:[sharedActionSheet numberOfButtons] - 1];
	
	return sharedActionSheet;
}

#pragma mark - UIActionSheet Delegate

+ (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == [actionSheet cancelButtonIndex] && _cancelBlock) {
		_cancelBlock(actionSheet);
	} else if (_optionBlock) {
		NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
		_optionBlock(actionSheet, buttonIndex, buttonTitle);
	}
}

@end
