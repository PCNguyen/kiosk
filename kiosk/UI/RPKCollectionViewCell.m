//
//  RPKCollectionViewCell.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKCollectionViewCell.h"

@implementation RPKCollectionViewCell

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
	/* Override by subview */
}

- (CGRect)adjustedBounds
{
	CGFloat xOffset = self.paddings.left;
	CGFloat yOffset = self.paddings.top;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	/** Overriden by subclass */
}

@end
