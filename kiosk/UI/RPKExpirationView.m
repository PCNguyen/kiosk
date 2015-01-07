//
//  RPKExpirationView.m
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <AppSDK/AppLibScheduler.h>

#import "RPKExpirationView.h"

@interface RPKExpirationView ()

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) ALScheduledTask *countDownTask;

@end

@implementation RPKExpirationView

#pragma mark - View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		[self addSubview:self.countdownLabel];
		[self addConstraints:[self.countdownLabel ul_centerAlignWithView:self]];
	}
	
	return self;
}

#pragma mark - Label

- (UILabel *)countdownLabel
{
	if (!_countdownLabel) {
		_countdownLabel = [[UILabel alloc] init];
		_countdownLabel.font = [UIFont boldSystemFontOfSize:40.0f];
		_countdownLabel.textColor = [UIColor redColor];
	}
	
	return _countdownLabel;
}

- (void)refreshLabel
{
	self.countdownLabel.text = [NSString stringWithFormat:@"Auto Logout In %.0f seconds", self.timeRemaining];
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
		}];
		_countDownTask.startImmediately = NO;
	}
	
	return _countDownTask;
}

@end
