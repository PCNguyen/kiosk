//
//  RPKNavigationItem.m
//  Kiosk
//
//  Created by PC Nguyen on 4/10/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKNavigationItem.h"
#import "UIImage+RPK.h"

@interface RPKNavigationItem ()

@property (nonatomic, strong) UIImageView *backArrow;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RPKNavigationItem

- (instancetype)initWithTitle:(NSString *)title
{
	if (self = [super initWithFrame:CGRectZero]) {
		[self addSubview:self.backArrow];
		self.titleLabel.text = title;
		[self addSubview:self.titleLabel];
	}
	
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.backArrow.frame = [self backArrowFrame];
	self.titleLabel.frame = [self titleLabelFrame:self.backArrow.frame];
}

#pragma mark - Title Label

- (CGRect)titleLabelFrame:(CGRect)backArrowFrame
{
	CGFloat xSpacing = 5.0f;
	CGFloat xOffset = CGRectGetMaxX(backArrowFrame) + xSpacing;
	CGFloat yOffset = 0.0f;
	CGFloat width = CGRectGetWidth(self.bounds) - xOffset;
	CGFloat height = CGRectGetHeight(self.bounds);
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.textAlignment = NSTextAlignmentLeft;
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	
	return _titleLabel;
}

#pragma mark - Back Arrow

- (CGRect)backArrowFrame
{
	CGFloat yPadding = 6.0f;
	CGFloat xOffset = 0.0f;
	CGFloat yOffset = yPadding;
	CGFloat height = CGRectGetHeight(self.bounds) - 2*yPadding;
	CGFloat width = height * 3/5;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)backArrow
{
	if (!_backArrow) {
		_backArrow = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_back.png"]];
		_backArrow.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _backArrow;
}

@end
