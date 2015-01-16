//
//  UIFont+RP.h
//  Reputation
//
//  Created by PC Nguyen on 3/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (RP)

+ (UIFont *)rp_fontWithSize:(CGFloat)size;
+ (UIFont *)rp_boldFontWithSize:(CGFloat)size;
+ (UIFont *)rp_extraBoldFontWithSize:(CGFloat)size;

+ (UIFont *)rp_standardFont;
+ (UIFont *)rp_standardBoldFont;
+ (UIFont *)rp_standardExtraBoldFont;

+ (UIFont *)rp_subFont;
+ (UIFont *)rp_subBoldFont;
+ (UIFont *)rp_subExtraBoldFont;

@end
