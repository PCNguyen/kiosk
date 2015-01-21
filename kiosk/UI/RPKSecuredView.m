//
//  RPKSecuredView.m
//  Kiosk
//
//  Created by PC Nguyen on 1/20/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKSecuredView.h"

/*******************************
 *  RPKBorderView
 *******************************/
@interface RPKBorderView : UIView

@end

@implementation RPKBorderView

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 1.0f);
	CGContextSetRGBStrokeColor(context, 219/255.0, 194/255.0, 100/255.0f, 1.0f);
	CGContextStrokeRect(context, rect);
}

@end

/***************************
 *  RPKSecuredView
 ****************************/

#define kSVLockImageSize			CGSizeMake(44.0f, 44.0f)

@interface RPKSecuredView ()

@property (nonatomic, strong) RPKBorderView *borderView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UILabel *securedMessageLabel;

@end

@implementation RPKSecuredView

- (void)commonInit
{
	[self addSubview:self.borderView];
	[self addSubview:self.lockImageView];
	[self addSubview:self.securedMessageLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.lockImageView.frame = [self lockImageViewFrame];
	self.borderView.frame = [self borderFrame:self.lockImageView.frame];
	self.securedMessageLabel.frame = self.borderView.frame;
}

#pragma mark - Lock Image View

- (CGRect)lockImageViewFrame
{
	CGFloat width = kSVLockImageSize.width;
	CGFloat height = kSVLockImageSize.height;
	CGFloat yOffset = self.paddings.top;
	CGFloat xOffset = (self.bounds.size.width - width) / 2;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)lockImageView
{
	if (!_lockImageView) {
		_lockImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_lock_large.png"]];
		_lockImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _lockImageView;
}

- (void)setLockBackgroundColor:(UIColor *)color
{
	self.lockImageView.backgroundColor = color;
}

#pragma mark - Border View

- (CGRect)borderFrame:(CGRect)topFrame
{
	CGFloat xOffset = 0.0f;
	CGFloat yOffset = topFrame.origin.y + 0.6*topFrame.size.height;
	CGFloat width = self.bounds.size.width;
	CGFloat height = self.bounds.size.height - yOffset;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (RPKBorderView *)borderView
{
	if (!_borderView) {
		_borderView = [[RPKBorderView alloc] init];
		_borderView.backgroundColor = [UIColor clearColor];
	}
	
	return _borderView;
}

#pragma mark - Message View

- (UILabel *)securedMessageLabel
{
	if (!_securedMessageLabel) {
		_securedMessageLabel = [[UILabel alloc] init];
		_securedMessageLabel.textAlignment = NSTextAlignmentCenter;
		_securedMessageLabel.numberOfLines = 1;
	}
	
	return _securedMessageLabel;
}

- (void)setSecuredMessage:(NSAttributedString *)securedMessage
{
	self.securedMessageLabel.attributedText = securedMessage;
}

@end
