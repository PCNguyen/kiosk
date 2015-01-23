//
//  RPKExpirationViewController.m
//  Kiosk
//
//  Created by PC Nguyen on 1/22/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <JWGCircleCounter/JWGCircleCounter.h>
#import "RPKExpirationViewController.h"

#define kEVCTimerSize				CGSizeMake(400.0f, 400.0f)
#define kEVCTransitionDuration		0.25f

@interface RPKExpirationViewController () <JWGCircleCounterDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) JWGCircleCounter *circleCounter;

@end

@implementation RPKExpirationViewController

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
		_circleCounter.delegate = self;
		[_circleCounter ul_enableAutoLayout];
		[_circleCounter ul_fixedSize:kEVCTimerSize];
	}
	
	return _circleCounter;
}

- (void)startCountDown:(NSTimeInterval)timeRemain fromViewController:(UIViewController *)viewController
{
	[viewController presentViewController:self animated:YES completion:^{
		[self.circleCounter startWithSeconds:timeRemain];
	}];
}

- (void)stopCountDown
{
	[self.circleCounter stop];
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)circleCounterTimeDidExpire:(JWGCircleCounter *)circleCounter
{
	if ([self.delegate respondsToSelector:@selector(expirationViewControllerTimeExpired:)]) {
		[self.delegate expirationViewControllerTimeExpired:self];
	}
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
