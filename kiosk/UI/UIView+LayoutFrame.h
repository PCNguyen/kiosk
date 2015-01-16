//
//  UIView+LayoutFrame.h
//  Reputation
//
//  Created by PC Nguyen on 11/6/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RPDynamicHeight <NSObject>

/**
 *  provide the minimum content height based on fixed width.
 *	this indicate anything smaller than this height will either crush the content bounds or make it scroll.
 *
 *  @return the miminum content height
 */
- (CGFloat)minHeightForWidth:(CGFloat)width;

@end

@protocol RPDynamicWidth <NSObject>

/**
 *  provide the minimum content width based on fixed height.
 *	this indicate anything smaller than this width will either crush the content bounds or make it scroll.
 *
 *  @return the miminum content width
 */
- (CGFloat)minWidthForHeight:(CGFloat)height;

@end

@interface UIView (LayoutFrame)

/**
 *  configure a minimum height take into account the spacing if height > 0
 *  item must conformed to RPDynamicWidth protocol
 
 *  @param width   the constraint width
 *  @param spacing the spacing
 *
 *  @return the combination of minHeight and spacing, or 0 if height is 0 or view does not conform to protocol
 */
- (CGFloat)rp_minHeightForWidth:(CGFloat)width spacing:(CGFloat)spacing;

@end
