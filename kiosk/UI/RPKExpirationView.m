//
//  RPKExpirationView.m
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <AppSDK/AppLibScheduler.h>
#import <JWGCircleCounter/JWGCircleCounter.h>

#import "RPKExpirationView.h"

#define kEVTimerSize				CGSizeMake(400.0f, 400.0f)

@interface RPKExpirationView () <JWGCircleCounterDelegate>

@property (nonatomic, strong) JWGCircleCounter *circleCounter;

@end

@implementation RPKExpirationView

#pragma mark - View Life Cycle

- (void)commonInit
{
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2f];
	[self addSubview:self.circleCounter];
	[self addConstraints:[self.circleCounter ul_centerAlignWithView:self]];
}

#pragma mark - Counter

- (JWGCircleCounter *)circleCounter
{
	if (!_circleCounter) {
		_circleCounter = [[JWGCircleCounter alloc] init];
		_circleCounter.timerLabel.font = [UIFont rpk_thinFontWithSize:90.0f];
		_circleCounter.timerLabel.textColor = [UIColor rpk_defaultBlue];
		_circleCounter.circleFillColor = [UIColor whiteColor];
		_circleCounter.circleColor = [UIColor rpk_borderColor];
		_circleCounter.circleBackgroundColor = [UIColor rpk_defaultBlue];
		_circleCounter.circleTimerWidth = 5.0f;
		_circleCounter.timerLabelHidden = NO;
		_circleCounter.delegate = self;
		[_circleCounter ul_enableAutoLayout];
		[_circleCounter ul_fixedSize:kEVTimerSize];
	}
	
	return _circleCounter;
}

#pragma mark - Count Down

- (void)startCountDown
{
	[self.circleCounter startWithSeconds:self.timeRemaining];
}

- (void)stopCountDown
{
	[self.circleCounter stop];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([self.delegate respondsToSelector:@selector(expirationViewDidReceivedTap:)]) {
		[self.delegate expirationViewDidReceivedTap:self];
	}
	
	return nil;
}

- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter
{
	if ([self.delegate respondsToSelector:@selector(expirationViewTimeExpired:)]) {
		[self.delegate expirationViewTimeExpired:self];
	}
}

@end
