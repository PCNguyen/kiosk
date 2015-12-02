//
//  UIView+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIView+UL.h"

@implementation UIView (Extension)

#pragma mark - Subview Handling

- (BOOL)ul_addSubviewIfNotExist:(UIView *)view {
    BOOL viewAdded = NO;
    
    if (![self.subviews containsObject:view]) {
        [self addSubview:view];
        viewAdded = YES;
    }
    
    return viewAdded;
}

- (BOOL)ul_addSubviewIfNoDuplicateClassExist:(UIView *)view {
    Class viewClass = [view class];
    
    BOOL classExist = NO;
    
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:viewClass]) {
            classExist = YES;
            break;
        }
    }
    
    if (!classExist) {
        [self addSubview:view];
    }
    
    return (!classExist);
}

- (void)ul_addSubView:(UIView *)subView
	 animateFromPoint:(CGPoint)point
		 zoomableView:(UIView *)zoomView
			 minScale:(CGSize)scale
		   completion:(void (^)(void))completionBlock
{
    CGPoint center = zoomView.center;
    [zoomView  setTransform:CGAffineTransformMakeScale(scale.width, scale.height)];
    subView.alpha = 0.0f;
    zoomView.center = point;
	
    [self ul_addSubviewIfNotExist:subView];
    [self ul_addSubviewIfNotExist:zoomView];
	
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         zoomView.center = center;
                         [zoomView  setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
                         subView.alpha = 1.0f;
                     }
                     completion:^(BOOL success) {
						 if (completionBlock) {
							 completionBlock();
						 }
						 
                     }];
}

- (void)ul_removeFromSuperviewAnimateToPoint:(CGPoint)point
								zoomableView:(UIView *)zoomView
									minScale:(CGSize)scale
								  completion:(void (^)(void))completion
{
    CGRect startFrame = zoomView.frame;
    self.alpha = 1;
    [self.superview ul_addSubviewIfNotExist:zoomView];
	
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         zoomView.center = point;
                         [zoomView  setTransform:CGAffineTransformMakeScale(scale.width, scale.height)];
                         self.alpha = 0;
                     }
                     completion:^(BOOL success){
						 
                         [self removeFromSuperview];
                         [zoomView removeFromSuperview];
                         [zoomView  setTransform:CGAffineTransformMakeScale(1, 1)];
                         zoomView.frame = startFrame;
						 
                         if (completion) {
                             completion();
						 }
                     }];
}

#pragma mark - Round Corner

- (void)ul_roundCorners:(UIRectCorner)rectCorner radius:(float)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:rectCorner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer setMask:maskLayer];
}

- (void)ul_round
{
	CGRect frame = CGRectInset(self.bounds, 0.5f, 0.5f);
	
	UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:frame];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    [self.layer setMask:maskLayer];
}

#pragma mark - Keyboard Handling

- (void)ul_animateKeyboardFromNotification:(NSNotification *)notification
{
	BOOL isVisible = [[notification name] isEqualToString:UIKeyboardWillShowNotification];
	
	NSTimeInterval keyboardAnimationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect convertedKeyboardRect = [self convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = convertedKeyboardRect.size.height;
    
    UIView *firstResponderView = [self __firstResponderSubView];
    CGFloat yOffset = firstResponderView.frame.origin.y;
    BOOL isScrollView = [[self class] isSubclassOfClass:[UIScrollView class]];
    
	[UIView animateWithDuration:keyboardAnimationDuration
					 animations:^(void)
	 {
		 if (isScrollView) {
			 if (isVisible) {
				 [(UIScrollView *)self setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, keyboardHeight, 0.0f)];
			 } else {
				 [(UIScrollView *)self setContentInset:UIEdgeInsetsZero];
			 }
		 } else {
			 if (isVisible) {
				 [self setFrame:CGRectOffset(self.frame, 0.0f, -keyboardHeight/2)];
			 } else {
				 [self setFrame:CGRectOffset(self.frame, 0.0f, keyboardHeight/2)];
			 }
		 }
		 
	 } completion:^(BOOL finished) {
		 if (isScrollView) {
			 if (isVisible) {
				 [(UIScrollView *)self setContentOffset:CGPointMake(0.0f, yOffset) animated:YES];
			 } else {
				 [(UIScrollView *)self setContentOffset:CGPointZero animated:YES];
			 }
		 }
	 }];
}

- (UIView *)__firstResponderSubView
{
	for (UIView *subView in self.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    
    return self;
}

#pragma mark - Animation

- (void)ul_rightFlipToView:(UIView *)toView duration:(CGFloat)duration
{
	[self ul_rightFlipToView:toView duration:duration completion:^{}];
}

- (void)ul_rightFlipToView:(UIView *)toView duration:(CGFloat)duration completion:(void (^)())completion
{
	[self __flip:UIViewAnimationOptionTransitionFlipFromRight toView:toView duration:duration completion:completion];
}

- (void)ul_leftFlipToView:(UIView *)toView duration:(CGFloat)duration
{
	[self ul_leftFlipToView:toView duration:duration completion:^{}];
}

- (void)ul_leftFlipToView:(UIView *)toView duration:(CGFloat)duration completion:(void (^)())completion
{
	[self __flip:UIViewAnimationOptionTransitionFlipFromRight toView:toView duration:duration completion:completion];
}

#pragma mark - Private

- (void)__flip:(UIViewAnimationOptions)transition toView:(UIView *)toView duration:(CGFloat)duration completion:(void (^)())completion
{
	toView.hidden = NO;
	
	[UIView transitionFromView:self
						toView:toView
					  duration:duration
					   options:UIViewAnimationOptionTransitionFlipFromRight
					completion:^(BOOL finished) {
						self.hidden = YES;
						completion();
					}];
}

#pragma mark - Interaction

- (UITapGestureRecognizer *)ul_addTapGestureWithTarget:(id)target action:(SEL)action
{
	self.userInteractionEnabled = YES;
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 1;
	[self addGestureRecognizer:tapGesture];
	
	return tapGesture;
}

@end
