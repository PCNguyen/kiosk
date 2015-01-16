//
//  UITextField+RP.m
//  Reputation
//
//  Created by PC Nguyen on 10/30/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UITextField+RP.h"
#import "UIFont+RP.h"
#import "UIColor+RP.h"

@implementation UITextField (RP)

+ (instancetype)rp_textFieldTemplate
{
	UITextField *textField = [[UITextField alloc] init];
	textField.backgroundColor = [UIColor whiteColor];
	textField.font = [UIFont rp_boldFontWithSize:14.0f];
	textField.layer.cornerRadius = 2.0f;
	textField.layer.borderWidth = 0.6;
	textField.layer.borderColor = [[UIColor rp_borderColor] CGColor];
	textField.layer.masksToBounds = YES;
	textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
	
	return textField;
}

@end
