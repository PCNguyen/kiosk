//
//  RPKNoConnectivityController.m
//  Kiosk
//
//  Created by PC Nguyen on 1/30/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKNoConnectivityController.h"

#define kNCCTransitionDuration		0.25f

@interface RPKNoConnectivityController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation RPKNoConnectivityController

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
	
	self.view.backgroundColor = [[UIColor rpk_backgroundColor] colorWithAlphaComponent:0.6f];
	
	[self.view addSubview:self.messageLabel];
	[self.view ul_addConstraints:[self.messageLabel ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 40.0f, kUIViewUnpinInset, 40.0f)] priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.messageLabel ul_centerAlignWithView:self.view]];
}

- (UILabel *)messageLabel
{
	if (!_messageLabel) {
		_messageLabel = [[UILabel alloc] init];
		_messageLabel.font = [UIFont rpk_thinFontWithSize:40.0f];
		_messageLabel.textAlignment = NSTextAlignmentCenter;
		_messageLabel.textColor = [UIColor rpk_darkGray];
		_messageLabel.text = NSLocalizedString(@"No Connectivity!\nWill resume when connection restored.", nil);
		_messageLabel.numberOfLines = 0;
		[_messageLabel ul_enableAutoLayout];
	}
	
	return _messageLabel;
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
	return kNCCTransitionDuration;
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
		
		[self animate:^{
			toViewController.view.alpha = 1.0f;
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
	[UIView animateWithDuration:kNCCTransitionDuration delay:0
		 usingSpringWithDamping:500 initialSpringVelocity:15
						options:0 animations:animationBlock
					 completion:completionBlock];
	
}

@end
