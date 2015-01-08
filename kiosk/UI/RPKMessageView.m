//
//  RPKMessageView.m
//  kiosk
//
//  Created by PC Nguyen on 1/8/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKMessageView.h"
#import <AppSDK/AppLibExtension.h>

@interface RPKMessageView ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *actionButton;

@end

@implementation RPKMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.messageLabel];
		[self addSubview:self.actionButton];
		
		[self addConstraints:[self.messageLabel ul_pinWithInset:UIEdgeInsetsMake(0.0f, kUIViewAquaDistance, 0.0f, kUIViewUnpinInset)]];
		[self addConstraints:[self.actionButton ul_horizontalAlign:NSLayoutFormatAlignAllCenterY withView:self.messageLabel distance:kUIViewAquaDistance leftToRight:NO]];
	}
	
	return self;
}

- (UILabel *)messageLabel
{
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont systemFontOfSize:20.0f];
		_messageLabel.textColor = [UIColor lightGrayColor];
		_messageLabel.text = @"Error viewing page ?";
		[_messageLabel ul_enableAutoLayout];
	}
	
	return _messageLabel;
}

- (UIButton *)actionButton
{
	if (!_actionButton) {
		_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		NSString *title = @"Reload";
		NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont systemFontOfSize:20.0f]
																	   textColor:[UIColor blueColor]];
		NSAttributedString *selAttributedTitle = [title al_attributedStringWithFont:[UIFont systemFontOfSize:20.0f]
																		  textColor:[UIColor lightGrayColor]];
		[_actionButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
		[_actionButton setAttributedTitle:selAttributedTitle forState:UIControlStateSelected];
		[_actionButton addTarget:self action:@selector(handleActionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[_actionButton ul_enableAutoLayout];
	}
	
	return _actionButton;
}

- (void)handleActionButtonTapped:(id)sender
{
	if ([self.delegate respondsToSelector:@selector(messagViewActionTapped:)]) {
		[self.delegate messagViewActionTapped:self];
	}
}

@end
