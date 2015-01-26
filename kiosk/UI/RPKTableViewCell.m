//
//  RPKTableViewCell.m
//  Kiosk
//
//  Created by PC Nguyen on 1/26/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKTableViewCell.h"
#import "RPProtocolFactory.h"

@implementation RPKTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	/** Overriden by subclass */
}

- (void)prepareForReuse
{
	for (UIView *subView in [self.contentView subviews]) {
		if ([subView conformsToProtocol:@protocol(RPReusableItem)]) {
			[(id<RPReusableItem>)subView reset];
		}
	}
}

@end
