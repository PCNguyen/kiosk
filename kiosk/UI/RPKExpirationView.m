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

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
 
	UIColor * lightColor = [UIColor ul_colorWithR:220 G:220 B:220 A:1.0f];
	UIColor * darkColor = [UIColor ul_colorWithR:0 G:0 B:0 A:1.0f];
 
	drawSymetricGradient(context, self.bounds, darkColor.CGColor, lightColor.CGColor);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[] = { 0.0, 1.0 };
 
	NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
 
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
 
	CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
 
	CGContextSaveGState(context);
	CGContextAddRect(context, rect);
	CGContextClip(context);
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(context);
 
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

void drawSymetricGradient(CGContextRef context, CGRect rect, CGColorRef outerColor, CGColorRef innerColor)
{
	CGRect topRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height / 2);
	drawLinearGradient(context, topRect, outerColor, innerColor);
	
	CGRect bottomRect = CGRectMake(rect.origin.x, rect.size.height / 2, rect.size.width, rect.size.height / 2);
	drawLinearGradient(context, bottomRect, innerColor, outerColor);
}

#pragma mark - Label

- (UILabel *)countdownLabel
{
	if (!_countdownLabel) {
		_countdownLabel = [[UILabel alloc] init];
		_countdownLabel.font = [UIFont boldSystemFontOfSize:40.0f];
		_countdownLabel.textColor = [UIColor redColor];
		[_countdownLabel ul_enableAutoLayout];
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
	self.countDownTask = nil;
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
