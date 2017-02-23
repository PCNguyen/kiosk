//
//  RPKExpirationViewController.m
//  Kiosk
//
//  Created by PC Nguyen on 1/22/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <JWGCircleCounter/JWGCircleCounter.h>
#import "AppLibExtension.h"
#import "AppLibScheduler.h"

#import "RPKExpirationViewController.h"

#define kEVCTimerSize				CGSizeMake(450.0f, 450.0f)
#define kEVCButtonSize				CGSizeMake(160.0f, 60.0f)

#define kEVCTransitionDuration		0.25f

@interface RPKExpirationViewController () <JWGCircleCounterDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) JWGCircleCounter *circleCounter;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UIButton *continueButton;
@property (nonatomic, strong) ALScheduledTask *countDownTask;

@end

@implementation RPKExpirationViewController

- (void)dealloc
{

}

- (instancetype)init
{
	if (self = [super init]) {
		self.modalPresentationStyle = UIModalPresentationCustom;
		self.transitioningDelegate = self;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.circleCounter addSubview:self.messageLabel];
	[self.circleCounter addConstraints:[self.messageLabel ul_pinWithInset:UIEdgeInsetsMake(80.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
	
	[self.circleCounter addSubview:self.continueButton];
	[self.circleCounter addConstraints:[self.continueButton ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, kUIViewUnpinInset, 60.0f, kUIViewUnpinInset)]];
	[self.circleCounter addConstraint:[self.continueButton ul_centerAlignWithView:self.circleCounter direction:@"V"]];
	
	[self.circleCounter addSubview:self.unitLabel];
	[self.circleCounter addConstraints:[self.unitLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.continueButton distance:40.0f topToBottom:YES]];
	
	[self.view addSubview:self.circleCounter];
	[self.view addConstraints:[self.circleCounter ul_centerAlignWithView:self.view]];
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
		[_circleCounter ul_enableAutoLayout];
		[_circleCounter ul_fixedSize:kEVCTimerSize];
	}
	
	return _circleCounter;
}

- (void)startCountDown:(NSTimeInterval)timeRemain
{
	[self.circleCounter startWithSeconds:timeRemain];
	[self.countDownTask start];
}

- (void)stopCountDown:(BOOL)expired
{
	if (_circleCounter) {
		[self.circleCounter reset];
	}
	
	if (_countDownTask) {
		[self.countDownTask stop];
	}
	
	[self dismissViewControllerAnimated:YES completion:^{
		if (expired) {
			if ([self.delegate respondsToSelector:@selector(expirationViewControllerTimeExpired:)]) {
				[self.delegate expirationViewControllerTimeExpired:self];
			}
		}
	}];
}

- (ALScheduledTask *)countDownTask
{
	if (!_countDownTask) {
		__weak RPKExpirationViewController *selfPointer = self;
		_countDownTask = [[ALScheduledTask alloc] initWithTaskInterval:1 taskBlock:^{
			if ([selfPointer.circleCounter didFinish]) {
				[selfPointer stopCountDown:YES];
			}
		}];
	}
	
	return _countDownTask;
}

#pragma mark - Static UI Element

- (UILabel *)messageLabel
{
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont rpk_thinFontWithSize:26.0f];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.textColor = [UIColor rpk_mediumGray];
		_messageLabel.text = NSLocalizedString(@"Your session will\nautomatically log out in", nil);
		_messageLabel.numberOfLines = 0;
		[_messageLabel ul_enableAutoLayout];
		[_messageLabel ul_addTapGestureWithTarget:self action:@selector(handleMessageTapped:)];
	}
	
	return _messageLabel;
}

- (UILabel *)unitLabel
{
	if (!_unitLabel) {
		_unitLabel = [[UILabel alloc] init];
		_unitLabel.font = [UIFont rpk_thinFontWithSize:24.0f];
		_unitLabel.textAlignment = NSTextAlignmentCenter;
		_unitLabel.textColor = [UIColor rpk_mediumGray];
		_unitLabel.text = NSLocalizedString(@"seconds", nil);
		[_unitLabel ul_enableAutoLayout];
	}
	
	return _unitLabel;
}

- (UIButton *)continueButton
{
	if (!_continueButton) {
		_continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		NSString *title = NSLocalizedString(@"Continue Review", nil);
		NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_fontWithSize:18.0f] textColor:[UIColor rpk_defaultBlue]];
		NSAttributedString *highLightTitle = [title al_attributedStringWithFont:[UIFont rpk_fontWithSize:18.0f] textColor:[UIColor rpk_lightGray]];
		[_continueButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
		[_continueButton setAttributedTitle:highLightTitle forState:UIControlStateHighlighted];
		[_continueButton addTarget:self action:@selector(handleContinueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[_continueButton ul_enableAutoLayout];
		[_continueButton ul_fixedSize:kEVCButtonSize];
		
		_continueButton.layer.cornerRadius = 2.0f;
		_continueButton.layer.borderWidth = 1.0f;
		_continueButton.layer.borderColor = [[UIColor rpk_defaultBlue] CGColor];
		_continueButton.layer.masksToBounds = YES;
	}
	
	return _continueButton;
}

- (void)handleContinueButtonTapped:(id)sender
{
	[self stopCountDown:NO];
}

- (void)handleMessageTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Transition

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
	return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return kEVCTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	UIView *containerView = [transitionContext containerView];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	if (toViewController.isBeingPresented) {
		[fromViewController.view ul_blur];
		[containerView addSubview:toViewController.view];
		toViewController.view.alpha = 0.0f;
		self.circleCounter.alpha = 0.5f;
		self.circleCounter.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
		
		[self animate:^{
			toViewController.view.alpha = 1.0f;
			self.circleCounter.transform = CGAffineTransformIdentity;
			self.circleCounter.alpha = 1.0f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
		
	} else {
		[toViewController.view ul_clearBlur];
		[self animate:^{
			fromViewController.view.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[fromViewController.view removeFromSuperview];
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
}

- (void)animate:(void (^)())animationBlock completion:(void (^)(BOOL finished))completionBlock
{
	[UIView animateWithDuration:kEVCTransitionDuration delay:0
		 usingSpringWithDamping:500 initialSpringVelocity:15
						options:0 animations:animationBlock
					 completion:completionBlock];
	
}

@end
