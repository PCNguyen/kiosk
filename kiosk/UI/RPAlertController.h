//
//  RPAlertController.h
//  Reputation
//
//  Created by PC Nguyen on 10/29/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LayoutFrame.h"

@class RPAlertButton;

typedef enum {
	AlertButtonStyleDefault,
	AlertButtonStyleCancel,
	AlertButtonStyleDestructive,
} RPAlertButtonStyle;

typedef void(^RPAlertButtonAction)(RPAlertButton *alertButton);
typedef void(^RPAlertTextFieldStyleHandler)(UITextField *textField);

@interface RPAlertButton : NSObject

- (instancetype)initWithTitle:(NSString *)title
						style:(RPAlertButtonStyle)style
					   action:(RPAlertButtonAction)actionHandler;

@end

@interface RPAlertController : UIViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (instancetype)initWithTitleView:(UIView<RPDynamicHeight> *)titleView
					  messageView:(UIView<RPDynamicHeight> *)messageView;

- (void)addButtonTitle:(NSString *)title
				 style:(RPAlertButtonStyle)style
				action:(RPAlertButtonAction)actionHandler;

- (void)addTextFieldWithStyleHandler:(RPAlertTextFieldStyleHandler)styleHandler;

- (NSArray *)textFields;

@end
