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
		
		[self addConstraints:[self.messageLabel ul_pinWithInset:UIEdgeInsetsMake(0.0f, 30.0f, 0.0f, kUIViewUnpinInset)]];
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
		[_messageLabel ul_enableAutoLayout];
	}
	
	return _messageLabel;
}

- (UIButton *)actionButton
{
	if (!_actionButton) {
		_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
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

- (void)setMessageType:(RPKMessageType)messageType
{
	_messageType = messageType;
	
	switch (messageType) {
		case MessageSwitchAccount:
			self.messageLabel.text = @"Not you?";
			[self setActionButtonTitle:@"Switch Account"];
			break;
		case MessageReloadPage:
			self.messageLabel.text = @"Error Viewing Page?";
			[self setActionButtonTitle:@"Reload"];
		default:
			break;
	}
}

- (void)setActionButtonTitle:(NSString *)title
{
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont systemFontOfSize:20.0f]
																   textColor:[UIColor blueColor]];
	NSAttributedString *selAttributedTitle = [title al_attributedStringWithFont:[UIFont systemFontOfSize:20.0f]
																	  textColor:[UIColor lightGrayColor]];
	[self.actionButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[self.actionButton setAttributedTitle:selAttributedTitle forState:UIControlStateSelected];
}

@end
