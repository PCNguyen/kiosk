//
//  UIFont+RP.m
//  Reputation
//
//  Created by PC Nguyen on 3/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIFont+RP.h"

@implementation UIFont (RP)

+ (UIFont *)rp_fontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-300" size:size];
}

+ (UIFont *)rp_boldFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-500" size:size];
}

+ (UIFont *)rp_extraBoldFontWithSize:(CGFloat)size
{
	return [UIFont fontWithName:@"MuseoSans-700" size:size];
}

+ (UIFont *)rp_standardFont
{
	return [self rp_fontWithSize:14.0f];
}

+ (UIFont *)rp_standardBoldFont
{
	return [self rp_boldFontWithSize:14.0f];
}

+ (UIFont *)rp_standardExtraBoldFont
{
	return [self rp_extraBoldFontWithSize:14.0f];
}

+ (UIFont *)rp_subFont
{
	return [self rp_fontWithSize:13.0f];
}

+ (UIFont *)rp_subBoldFont
{
	return [self rp_boldFontWithSize:13.0f];
}

+ (UIFont *)rp_subExtraBoldFont
{
	return [self rp_extraBoldFontWithSize:13.0f];
}

@end
