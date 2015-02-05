//
//  RPKReloadView.m
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKReloadView.h"

@interface RPKReloadView ()

@property (nonatomic, strong) UIImageView *reloadImageView;
@property (nonatomic, strong) UILabel *reloadLabel;

@end

@implementation RPKReloadView

- (void)commonInit
{
	self.spacings = CGSizeMake(10.0f, 0.0f);
	self.paddings = UIEdgeInsetsMake(5.0f, 0.0f, 5.0f, 0.0f);
	[self addSubview:self.reloadImageView];
	[self addSubview:self.reloadLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.reloadImageView.frame = [self reloadImageFrame];
	self.reloadLabel.frame = [self reloadLabelFrame:self.reloadImageView.frame];
}

#pragma mark - UI

- (CGRect)reloadImageFrame
{
	CGFloat xOffset = self.paddings.left;
	CGFloat yOffset = self.paddings.top;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
	CGFloat width = height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)reloadImageView
{
	if (!_reloadImageView) {
		_reloadImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_refresh.png"]];
		_reloadImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _reloadImageView;
}

- (CGRect)reloadLabelFrame:(CGRect)preferenceFrame
{
	CGFloat xOffset = preferenceFrame.origin.x + preferenceFrame.size.width + self.spacings.width;
	CGFloat yOffset = self.paddings.top;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)reloadLabel
{
	if (!_reloadLabel) {
		_reloadLabel = [[UILabel alloc] init];
		_reloadLabel.backgroundColor = [UIColor clearColor];
		_reloadLabel.font = [UIFont rpk_fontWithSize:14.0f];
		_reloadLabel.textColor = [UIColor rpk_defaultBlue];
		_reloadLabel.textAlignment = NSTextAlignmentLeft;
		_reloadLabel.text = NSLocalizedString(@"Trouble viewing this page?", nil);
	}
	
	return _reloadLabel;
}

@end
