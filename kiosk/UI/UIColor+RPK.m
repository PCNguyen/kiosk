//
//  UIColor+RPK.m
//  kiosk
//
//  Created by PC Nguyen on 1/8/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "UIColor+RPK.h"
#import "RPKUIKit.h"

@implementation UIColor (RPK)

+ (UIColor *)rpk_defaultBlue
{
	return [UIColor ul_colorWithHexString:@"#147aa4"];
}

+ (UIColor *)rpk_brightBlue
{
	return [UIColor ul_colorWithHexString:@"#4ebfeb"];
}

@end
