//
//  UITextField+RP.m
//  Reputation
//
//  Created by PC Nguyen on 10/30/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UITextField+RP.h"
#import "UIFont+RPK.h"
#import "UIColor+RPK.h"

@implementation UITextField (RP)

+ (instancetype)rp_textFieldTemplate
{
	UITextField *textField = [[UITextField alloc] init];
	textField.backgroundColor = [UIColor whiteColor];
	textField.font = [UIFont rpk_boldFontWithSize:20.0f];
	textField.layer.cornerRadius = 2.0f;
	textField.layer.borderWidth = 0.6;
	textField.layer.borderColor = [[UIColor rpk_borderColor] CGColor];
	textField.layer.masksToBounds = YES;
	textField.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 0);
	
	return textField;
}

@end
