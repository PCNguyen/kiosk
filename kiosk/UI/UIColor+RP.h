//
//  UIColor+RP.h
//  Reputation
//
//  Created by PC Nguyen on 4/1/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RP)

#pragma mark - General

+ (UIColor *)rp_defaultBlue;

+ (UIColor *)rp_brightBlue;

+ (UIColor *)rp_green;

+ (UIColor *)rp_lightGreen;

+ (UIColor *)rp_yellow;

+ (UIColor *)rp_orrange;

+ (UIColor *)rp_red;

+ (UIColor *)rp_mediumGrey;

+ (UIColor *)rp_darkGrey;

+ (UIColor *)rp_lightGrey;

#pragma mark - Element

+ (UIColor *)rp_pageBackGroundColor;

+ (UIColor *)rp_settingBackgroundColor;

+ (UIColor *)rp_contentBackgroundColor;

+ (UIColor *)rp_imageBackgroundColor;

+ (UIColor *)rp_linkViewBackgroundColor;

+ (UIColor *)rp_navigationHeaderColor;

+ (UIColor *)rp_borderColor;

+ (UIColor *)rp_colorForScore:(CGFloat)score;

+ (UIColor *)rp_locationTextColor;

+ (UIColor *)rp_authorTextColor;

+ (UIColor *)rp_linkTextColor;

+ (UIColor *)rp_starColor;

+ (UIColor *)rp_placeHolderColor;

@end
