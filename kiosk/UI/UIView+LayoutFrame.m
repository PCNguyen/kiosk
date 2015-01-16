//
//  UIView+LayoutFrame.m
//  Reputation
//
//  Created by PC Nguyen on 11/6/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIView+LayoutFrame.h"

@implementation UIView (LayoutFrame)

- (CGFloat)rp_minHeightForWidth:(CGFloat)width spacing:(CGFloat)spacing
{
	CGFloat height = 0;
	
	if ([self conformsToProtocol:@protocol(RPDynamicHeight)]) {
		height = [(id<RPDynamicHeight>)self minHeightForWidth:width];
		if (height > 0) {
			height += spacing;
		}
	}
	
	return height;
}

@end
