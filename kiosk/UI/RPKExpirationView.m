//
//  RPKExpirationView.m
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <AppSDK/AppLibScheduler.h>

#import "RPKExpirationView.h"
#import "RPKAlphaView.h"

@interface RPKExpirationView ()

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) ALScheduledTask *countDownTask;
@property (nonatomic, strong) RPKAlphaView *alphaView;

@end

@implementation RPKExpirationView

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.alphaView];
		[self addConstraints:[self.alphaView ul_pinWithInset:UIEdgeInsetsZero]];
		
		[self addSubview:self.countdownLabel];
		[self addConstraints:[self.countdownLabel ul_centerAlignWithView:self]];
		
		[self addSubview:self.messageLabel];
		[self addConstraints:[self.messageLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.countdownLabel distance:50.0f topToBottom:YES]];
		
		[self addSubview:self.infoLabel];
		[self addConstraints:[self.infoLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.countdownLabel distance:50.0f topToBottom:NO]];
	}
	
	return self;
}

#pragma mark - Gradient

- (RPKAlphaView *)alphaView
{
	if (!_alphaView) {
		_alphaView = [[RPKAlphaView alloc] init];
		_alphaView.alpha = 0.8f;
		[_alphaView ul_enableAutoLayout];
	}
	
	return _alphaView;
}

#pragma mark - Label

- (UILabel *)countdownLabel
{
	if (!_countdownLabel) {
		_countdownLabel = [[UILabel alloc] init];
		_countdownLabel.font = [UIFont boldSystemFontOfSize:120.0f];
		_countdownLabel.textColor = [UIColor redColor];
		_countdownLabel.textAlignment = NSTextAlignmentCenter;
		[_countdownLabel ul_enableAutoLayout];
	}
	
	return _countdownLabel;
}

- (UILabel *)messageLabel
{
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont systemFontOfSize:40.0f];
		_messageLabel.textColor = [UIColor yellowColor];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.text = @"Auto logout in";
		[_messageLabel ul_enableAutoLayout];
	}
	
	return _messageLabel;
}

- (UILabel *)infoLabel
{
	if (!_infoLabel) {
		_infoLabel = [[UILabel alloc] init];
		_infoLabel.font = [UIFont systemFontOfSize:40.0f];
		_infoLabel.textColor = [UIColor yellowColor];
		_infoLabel.textAlignment = NSTextAlignmentCenter;
		_infoLabel.text = @"Tap anywhere to continue";
		[_infoLabel ul_enableAutoLayout];
	}
	
	return _infoLabel;
}

- (void)refreshLabel
{
	self.countdownLabel.text = [NSString stringWithFormat:@"%.0f", self.timeRemaining];
}

#pragma mark - Count Down

- (void)startCountDown
{
	[self.countDownTask start];
}

- (void)stopCountDown
{
	[self.countDownTask stop];
}

- (ALScheduledTask *)countDownTask
{
	if (!_countDownTask) {
		__weak RPKExpirationView *selfPointer = self;
		_countDownTask = [[ALScheduledTask alloc] initWithTaskInterval:1 taskBlock:^{
			selfPointer.timeRemaining--;
			[selfPointer refreshLabel];
			[selfPointer checkExpired];
		}];
		_countDownTask.startImmediately = NO;
	}
	
	return _countDownTask;
}

- (void)checkExpired
{
	if (self.timeRemaining <= 0) {
		[self stopCountDown];
		if ([self.delegate respondsToSelector:@selector(expirationViewTimeExpired:)]) {
			[self.delegate expirationViewTimeExpired:self];
		}
	}
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([self.delegate respondsToSelector:@selector(expirationViewDidReceivedTap:)]) {
		[self.delegate expirationViewDidReceivedTap:self];
	}
	
	return nil;
}

@end
