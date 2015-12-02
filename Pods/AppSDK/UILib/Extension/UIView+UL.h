//
//  UIView+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

#pragma mark - Subview Handling

/**
 * Before adding a view, check its existence in the view hierachy of the superview
 */
- (BOOL)ul_addSubviewIfNotExist:(UIView *)view;

/**
 * Before adding a view, check if another view of the same class exist
 * in the hierachy of the superview
 */
- (BOOL)ul_addSubviewIfNoDuplicateClassExist:(UIView *)view;

/**
 * Add Subview and zoom out from a point in its parent view
 */
- (void)ul_addSubView:(UIView *)subView
	 animateFromPoint:(CGPoint)point
		 zoomableView:(UIView *)zoomView
			 minScale:(CGSize)scale
		   completion:(void (^)(void))completionBlock;

/**
 * Zoom in to a point in its parent view before removing
 */
- (void)ul_removeFromSuperviewAnimateToPoint:(CGPoint)point
								zoomableView:(UIView *)zoomView
									minScale:(CGSize)scale
								  completion:(void (^)(void))completion;

#pragma mark - Corner Rounding

/**
 * Round Selective Corner Of UIView
 */
- (void)ul_roundCorners:(UIRectCorner)rectCorner radius:(float)radius;

/**
 * Convert a square UIView into circle
 */
- (void)ul_round;

#pragma mark - Keyboard Notification

/**
 * Animated view up upon keyboard appearing
 */
- (void)ul_animateKeyboardFromNotification:(NSNotification *)notification;

#pragma mark - Animation

- (void)ul_rightFlipToView:(UIView *)toView duration:(CGFloat)duration;
- (void)ul_rightFlipToView:(UIView *)toView duration:(CGFloat)duration completion:(void (^)())completion;

- (void)ul_leftFlipToView:(UIView *)toView duration:(CGFloat)duration;
- (void)ul_leftFlipToView:(UIView *)toView duration:(CGFloat)duration completion:(void (^)())completion;

#pragma mark - Interaction

- (UITapGestureRecognizer *)ul_addTapGestureWithTarget:(id)target action:(SEL)action;

@end

