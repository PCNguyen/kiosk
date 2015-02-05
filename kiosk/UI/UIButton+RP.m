//
//  UIButton+RP.m
//  Reputation
//
//  Created by PC Nguyen on 7/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIButton+RP.h"
#import "RPKUIKit.h"
#import <AppSDK/AppLibExtension.h>

@implementation UIButton (RP)

+ (instancetype)rp_buttonWithIcon:(UIImage *)icon
							title:(NSAttributedString *)title
				  backgroundColor:(UIColor *)backgroundColor
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[customButton setImage:icon forState:UIControlStateNormal];
	[customButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, kUIButtonImageSpacing)];
	[customButton setAttributedTitle:title forState:UIControlStateNormal];
	[customButton setBackgroundColor:backgroundColor];
	
	return customButton;
}

+ (instancetype)rp_blueButtonWithTitle:(NSString *)title
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:16.0f] textColor:[UIColor whiteColor]];
	NSAttributedString *attributedSelectedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:16.0f] textColor:[UIColor ul_colorWithR:255 G:255 B:255 A:0.5f]];
	[customButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[customButton setAttributedTitle:attributedSelectedTitle forState:UIControlStateHighlighted];
	[customButton setBackgroundColor:[UIColor rpk_brightBlue]];
	
	return customButton;
}

@end
