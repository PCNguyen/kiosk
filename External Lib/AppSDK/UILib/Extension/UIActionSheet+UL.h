//
//  UIActionSheet+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OptionSelectedBlock)(UIActionSheet *actionSheet, NSInteger buttonIndex, NSString *buttonTitle);
typedef void (^OptionCanceledBlock)(UIActionSheet *actionSheet);

@interface UIActionSheet (UL)

+ (instancetype)ul_actionSheetWithTitle:(NSString *)title
					  cancelButtonTitle:(NSString *)cancelTitle
				 destructiveButtonTitle:(NSString *)destructiveTitle
					  otherButtonTitles:(NSArray *)titles
							   onCancel:(OptionCanceledBlock)cancelBlock
						 optionSelected:(OptionSelectedBlock)optionBlock;
@end
