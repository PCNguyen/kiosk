//
//  UIFont+RPK.h
//  Kiosk
//
//  Created by PC Nguyen on 1/20/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (RPK)

+ (UIFont *)rpk_thinFontWithSize:(CGFloat)size;
+ (UIFont *)rpk_fontWithSize:(CGFloat)size;
+ (UIFont *)rpk_boldFontWithSize:(CGFloat)size;
+ (UIFont *)rpk_extraBoldFontWithSize:(CGFloat)size;

@end
