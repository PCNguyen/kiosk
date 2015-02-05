//
//  RPKGoogleMessage.m
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKGoogleMessage.h"

@interface RPKGoogleMessage ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation RPKGoogleMessage

- (void)commonInit
{
	[self addSubview:self.logoImageView];
	[self addSubview:self.messageLabel];
	
	[self addConstraints:[self.messageLabel ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, self.paddings.bottom, self.paddings.right)]];
	[self addConstraints:[self.logoImageView ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.messageLabel distance:kUIViewAquaDistance topToBottom:YES]];
	[self addConstraints:[self.logoImageView ul_pinWithInset:UIEdgeInsetsMake(self.paddings.top, kUIViewUnpinInset, kUIViewUnpinInset, kUIViewUnpinInset)]];
}

- (UIImageView *)logoImageView
{
	if (!_logoImageView) {
		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_gplus.png"]];
		_logoImageView.contentMode = UIViewContentModeScaleAspectFit;
		[_logoImageView ul_enableAutoLayout];
		[_logoImageView ul_tightenContentWithPriority:UILayoutPriorityFittingSizeLevel];
	}
	
	return _logoImageView;
}

- (UILabel *)messageLabel
{
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.backgroundColor = [UIColor clearColor];
		_messageLabel.font = [UIFont rpk_boldFontWithSize:20.0f];
		_messageLabel.textColor = [UIColor rpk_mediumGray];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.text = @"You are leaving a review on Google+ Local";
		[_messageLabel ul_enableAutoLayout];
		[_messageLabel ul_tightenContentWithPriority:UILayoutPriorityDefaultHigh];
	}
	
	return _messageLabel;
}

@end
