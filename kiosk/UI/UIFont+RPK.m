//
//  UIFont+RPK.m
//  Kiosk
//
//  Created by PC Nguyen on 1/20/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "UIFont+RPK.h"

@implementation UIFont (RPK)

+ (UIFont *)rpk_thinFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-100" size:size];
}

+ (UIFont *)rpk_fontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-300" size:size];
}

+ (UIFont *)rpk_boldFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-500" size:size];
}

+ (UIFont *)rpk_extraBoldFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-700" size:size];
}

@end
