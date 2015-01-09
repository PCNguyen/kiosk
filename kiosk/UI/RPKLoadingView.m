//
//  RPKLoadingView.m
//  kiosk
//
//  Created by PC Nguyen on 1/9/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <SplittingTriangle/SplittingTriangle.h>
#import "RPKLoadingView.h"

#import "UIColor+RPK.h"

@interface RPKLoadingView ()

@property (nonatomic, strong) SplittingTriangle *animationView;

@end

@implementation RPKLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [[UIColor rpk_defaultBlue] colorWithAlphaComponent:0.7];
		[self addSubview:self.animationView];
		[self.animationView ul_fixedSize:CGSizeMake(200.0f, 200.0f)];
		[self addConstraints:[self.animationView ul_centerAlignWithView:self]];
	}
	
	return self;
}

- (void)showFromView:(UIView *)view
{
	[view ul_blur];
	self.frame = view.bounds;
	[view addSubview:self];
	
	self.animationView.paused = NO;
}

- (void)hide
{
	self.animationView.paused = YES;
	
	if (self.superview) {
		[self.superview ul_clearBlur];
		[self removeFromSuperview];
	}
}

- (SplittingTriangle *)animationView
{
	if (!_animationView) {
		_animationView = [[SplittingTriangle alloc] init];
		[_animationView setForeColor:[UIColor whiteColor]
					  andBackColor:[UIColor clearColor]];
		[_animationView setClockwise:YES];
		[_animationView setDuration:2.4f];
		[_animationView setRadius:25.0f];
		[_animationView ul_enableAutoLayout];
	}
	
	return _animationView;
}

@end
