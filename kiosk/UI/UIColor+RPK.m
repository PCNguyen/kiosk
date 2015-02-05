//
//  UIColor+RPK.m
//  kiosk
//
//  Created by PC Nguyen on 1/8/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKUIKit.h"
#import "UIColor+RPK.h"

@implementation UIColor (RPK)

+ (UIColor *)rpk_defaultBlue
{
	return [UIColor ul_colorWithHexString:@"#147aa4"];
}

+ (UIColor *)rpk_brightBlue
{
	return [UIColor ul_colorWithHexString:@"#4ebfeb"];
}

+ (UIColor *)rpk_darkGray
{
	return [UIColor ul_colorWithR:102 G:102 B:102 A:1.0f];
}

+ (UIColor *)rpk_mediumGray
{
	return [UIColor ul_colorWithR:154 G:154 B:154 A:1.0f];
}

+ (UIColor *)rpk_lightGray
{
	return [UIColor ul_colorWithR:173 G:174 B:174 A:1.0f];
}

+ (UIColor *)rpk_backgroundColor
{
	return [UIColor ul_colorWithR:246 G:246 B:246 A:1.0f];
}

+ (UIColor *)rpk_borderColor
{
	return [UIColor ul_colorWithR:216 G:216 B:216 A:1.0f];
}

@end
