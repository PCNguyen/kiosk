//
//  UILabel+DynamicHeight.m
//  Reputation
//
//  Created by PC Nguyen on 10/29/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UILabel+DynamicHeight.h"

@implementation UILabel (DynamicHeight)

- (CGFloat)minHeightForWidth:(CGFloat)width
{
	return [self sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
}

- (CGFloat)minWidthForHeight:(CGFloat)height
{
	return [self sizeThatFits:CGSizeMake(MAXFLOAT, height)].width;
}

@end
