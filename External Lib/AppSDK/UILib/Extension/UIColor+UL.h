//
//  UIColor+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (UL)

- (UIColor *)ul_darkenColorWithRatio:(CGFloat)ratio;

- (UIColor *)ul_ligthenColorWithRatio:(CGFloat)ratio;

+ (UIColor *)ul_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha;

+ (UIColor *)ul_colorWithHexString:(NSString *)hexString;

@end
