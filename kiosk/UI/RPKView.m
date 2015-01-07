//
//  RPKView.m
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKView.h"

@implementation RPKView

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		_paddings = UIEdgeInsetsZero;
		_spacings = CGSizeZero;
		
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	/** Overriden by subclass */
}

- (CGRect)adjustedBounds
{
	CGFloat xOffset = self.paddings.left;
	CGFloat yOffset = self.paddings.top;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

@end
