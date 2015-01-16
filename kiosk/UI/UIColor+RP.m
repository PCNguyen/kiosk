//
//  UIColor+RP.m
//  Reputation
//
//  Created by PC Nguyen on 4/1/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIColor+RP.h"

#define kUIColorExcelentThreshold			800
#define kUIColorGoodThreshold				600
#define kUIColorAverageThreshold			400
#define kUIColorFairThreshold				200
#define kUIColorPoorThreshold				0

#import <AppSDK/UILibExtension.h>

@implementation UIColor (RP)

+ (UIColor *)rp_defaultBlue
{
	return [UIColor ul_colorWithHexString:@"#147aa4"];
}

+ (UIColor *)rp_brightBlue
{
	return [UIColor ul_colorWithHexString:@"#4ebfeb"];
}

+ (UIColor *)rp_green
{
	return [UIColor ul_colorWithHexString:@"#1b9c33"];
}

+ (UIColor *)rp_lightGreen
{
	return [UIColor ul_colorWithHexString:@"#81b63f"];
}

+ (UIColor *)rp_yellow
{
	return [UIColor ul_colorWithHexString:@"#ce942c"];
}

+ (UIColor *)rp_orrange
{
	return [UIColor ul_colorWithHexString:@"#d25013"];
}

+ (UIColor *)rp_red
{
	return [UIColor ul_colorWithHexString:@"#c11717"];
}

+ (UIColor *)rp_mediumGrey
{
	return [UIColor ul_colorWithHexString:@"#999999"];
}

+ (UIColor *)rp_darkGrey
{
	return [UIColor ul_colorWithHexString:@"#666666"];
}

+ (UIColor *)rp_lightGrey
{
	return [UIColor ul_colorWithHexString:@"#bbbbbb"];
}

#pragma mark - Element

+ (UIColor *)rp_pageBackGroundColor
{
	return [UIColor whiteColor];
}

+ (UIColor *)rp_settingBackgroundColor
{
	return [UIColor ul_colorWithR:238 G:238 B:239 A:1.0f];
}

+ (UIColor *)rp_contentBackgroundColor
{
	return [UIColor whiteColor];
}

+ (UIColor *)rp_imageBackgroundColor
{
	return [UIColor ul_colorWithR:232 G:232 B:233 A:1.0f];
}

+ (UIColor *)rp_linkViewBackgroundColor
{
	return [UIColor ul_colorWithR:244 G:251 B:253 A:1.0f];
}

+ (UIColor *)rp_navigationHeaderColor
{
	return [UIColor rp_defaultBlue];
}

+ (UIColor *)rp_borderColor
{
	return [UIColor ul_colorWithHexString:@"#cccccc"];
}

+ (UIColor *)rp_colorForScore:(CGFloat)score
{
	if (score > kUIColorExcelentThreshold) {
		return [UIColor rp_green];
	} else if (score > kUIColorGoodThreshold) {
		return [UIColor rp_lightGreen];
	} else if (score > kUIColorAverageThreshold) {
		return [UIColor rp_yellow];
	} else if (score > kUIColorFairThreshold) {
		return [UIColor rp_orrange];
	} else if (score > kUIColorPoorThreshold) {
		return [UIColor rp_red];
	} else {
		return [UIColor rp_mediumGrey];
	}
}

+ (UIColor *)rp_locationTextColor
{
	return [UIColor rp_darkGrey];
}

+ (UIColor *)rp_authorTextColor
{
	return [UIColor blackColor];
}

+ (UIColor *)rp_linkTextColor
{
	return [UIColor rp_defaultBlue];
}

+ (UIColor *)rp_starColor
{
	return [UIColor ul_colorWithR:254 G:132 B:36 A:1.0f];
}

+ (UIColor *)rp_placeHolderColor
{
	return [UIColor ul_colorWithR:240 G:240 B:240 A:1.0f];
}

@end
