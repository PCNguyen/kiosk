//
//  UIView+Blur.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+Blur.h"
#import "UIImage+ImageEffects.h"

static int kUIViewBlurOverlayTag = -2000;

@implementation UIView (Blur)

- (UIImage *)ul_screenShot
{
	CGRect windowBounds = self.window.bounds;
	CGSize windowSize = windowBounds.size;
	
	UIGraphicsBeginImageContextWithOptions(windowSize, YES, 0.0);
	[self.window drawViewHierarchyInRect:windowBounds afterScreenUpdates:NO];
	UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return snapshot;
}

- (UIImageView *)__blurImageView
{
	UIImage *screenShot = [self ul_screenShot];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[screenShot applyBlurWithRadius:7.0f tintColor:nil saturationDeltaFactor:1.0f maskImage:nil]];
	imageView.frame = self.bounds;
	imageView.contentMode = UIViewContentModeScaleToFill;
	imageView.tag = kUIViewBlurOverlayTag;
	
	return imageView;
}

- (void)ul_blur
{
	[self ul_clearBlur];
	[self addSubview:[self __blurImageView]];
}

- (void)ul_clearBlur
{
	for (UIView *subView in self.subviews) {
		if (subView.tag == kUIViewBlurOverlayTag) {
			[subView removeFromSuperview];
		}
	}
}

@end
