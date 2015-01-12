//
//  RPKAlphaView.m
//  kiosk
//
//  Created by PC Nguyen on 1/12/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKAlphaView.h"

@implementation RPKAlphaView

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

@end
