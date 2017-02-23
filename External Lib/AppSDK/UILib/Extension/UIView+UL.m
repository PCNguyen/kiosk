//
//  UIView+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIView+UL.h"

@implementation UIView (Extension)

#pragma mark - Layout

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.left;
}

- (void)setX:(CGFloat)x {
    self.left = x;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.top;
}

- (void)setY:(CGFloat)y {
    self.top = y;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)ul_horizontalCenterInSuperview {
    [self ul_horizontalCenterInView:self.superview];
}

- (void)ul_horizontalCenterInView:(UIView *)v {
    self.left = floor(v.width/2 - self.width/2);
}

- (void)ul_verticalCenterInSuperview {
    [self ul_verticalCenterInView:self.superview];
}

- (void)ul_verticalCenterInView:(UIView *)v {
    self.top = floor(v.height/2 - self.height/2);
}

- (void)ul_centerInSuperview {
    [self ul_centerInView:self.superview];
}

- (void)ul_centerInView:(UIView *)v {
    self.frame = CGRectMake(floor(v.width/2 - self.width/2),
                            floor(v.height/2 - self.height/2),
                            self.width,
                            self.height);
}

- (void)ul_sizeToFitWithMargin:(CGFloat)margin {
    [self sizeToFit];
    self.height += margin;
    self.width += margin;
}

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
