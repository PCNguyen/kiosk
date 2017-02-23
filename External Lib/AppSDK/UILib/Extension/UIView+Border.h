//
//  UIView+Border.h
//  AppSDK
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ULBorderTop,
	ULBorderBottom,
	ULBorderLeft,
	ULBorderRight,
} UL_BorderPosition;

@interface UIView (Border)

#pragma mark - All Border

- (void)ul_enableBorder;
- (void)ul_removeBorder;
- (void)ul_setBorderThickness:(CGFloat)thickness padding:(UIEdgeInsets)paddings;
- (void)ul_setBorderColor:(UIColor *)color;

#pragma mark - Selective Border

- (void)ul_enableBorder:(UL_BorderPosition)position;
- (void)ul_removeBorder:(UL_BorderPosition)position;
- (void)ul_setBorder:(UL_BorderPosition)position thickness:(CGFloat)thickness padding:(UIEdgeInsets)paddings;
- (void)ul_setBorder:(UL_BorderPosition)position color:(UIColor *)color;

#pragma mark - Border Access

- (UIView *)ul_topBorder;
- (UIView *)ul_bottomBorder;
- (UIView *)ul_leftBorder;
- (UIView *)ul_rightBorder;

#pragma mark - Default Values

+ (CGFloat)ul_defaultBorderThickness;
+ (UIEdgeInsets)ul_defaultHorizontalPaddings;
+ (UIEdgeInsets)ul_defaultVerticalPaddings;
+ (UIColor *)ul_defaultBorderColor;

@end
