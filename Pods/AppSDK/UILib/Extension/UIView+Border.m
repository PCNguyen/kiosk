//
//  UIView+Border.m
//  AppSDK
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIView+Border.h"
#import "NSObject+AL.h"

@implementation UIView (Border)

- (void)ul_enableBorder
{
	[self ul_enableBorder:ULBorderTop];
	[self ul_enableBorder:ULBorderBottom];
	[self ul_enableBorder:ULBorderLeft];
	[self ul_enableBorder:ULBorderRight];
}

- (void)ul_removeBorder
{
	[self ul_removeBorder:ULBorderTop];
	[self ul_removeBorder:ULBorderBottom];
	[self ul_removeBorder:ULBorderLeft];
	[self ul_removeBorder:ULBorderRight];
}

- (void)ul_setBorderThickness:(CGFloat)thickness padding:(UIEdgeInsets)paddings
{
	[self ul_setBorder:ULBorderTop thickness:thickness padding:paddings];
	[self ul_setBorder:ULBorderBottom thickness:thickness padding:paddings];
	[self ul_setBorder:ULBorderLeft thickness:thickness padding:paddings];
	[self ul_setBorder:ULBorderRight thickness:thickness padding:paddings];
}

- (void)ul_setBorderColor:(UIColor *)color
{
	[self ul_setBorder:ULBorderTop color:color];
	[self ul_setBorder:ULBorderBottom color:color];
	[self ul_setBorder:ULBorderLeft color:color];
	[self ul_setBorder:ULBorderRight color:color];
}

#pragma mark - Selective Border

- (void)ul_enableBorder:(UL_BorderPosition)position
{
	switch (position) {
		case ULBorderTop:
			[self __enableTopBorder:YES];
			break;
		case ULBorderBottom:
			[self __enableBottomBorder:YES];
			break;
		case ULBorderLeft:
			[self __enableLeftBorder:YES];
			break;
		case ULBorderRight:
			[self __enableRightBorder:YES];
			break;
		default:
			break;
	}
}

- (void)ul_removeBorder:(UL_BorderPosition)position
{
	switch (position) {
		case ULBorderTop:
			[self __enableTopBorder:NO];
			break;
		case ULBorderBottom:
			[self __enableBottomBorder:NO];
			break;
		case ULBorderLeft:
			[self __enableLeftBorder:NO];
			break;
		case ULBorderRight:
			[self __enableRightBorder:NO];
			break;
		default:
			break;
	}
}

- (void)ul_setBorder:(UL_BorderPosition)position thickness:(CGFloat)thickness padding:(UIEdgeInsets)paddings
{
	CGRect updatedFrame = [self rp_frameForPosition:position thickness:thickness padding:paddings];
	
	switch (position) {
		case ULBorderTop:
			[self ul_topBorder].frame = updatedFrame;
			break;
		case ULBorderBottom:
			[self ul_bottomBorder].frame = updatedFrame;
			break;
		case ULBorderLeft:
			[self ul_leftBorder].frame = updatedFrame;
			break;
		case ULBorderRight:
			[self ul_rightBorder].frame = updatedFrame;
			break;
		default:
			break;
	}
}

- (void)ul_setBorder:(UL_BorderPosition)position color:(UIColor *)color
{
	switch (position) {
		case ULBorderTop:
			[self ul_topBorder].backgroundColor = color;
			break;
		case ULBorderBottom:
			[self ul_bottomBorder].backgroundColor = color;
			break;
		case ULBorderLeft:
			[self ul_leftBorder].backgroundColor = color;
			break;
		case ULBorderRight:
			[self ul_rightBorder].backgroundColor = color;
			break;
		default:
			break;
	}
}

#pragma mark - Top Border

- (void)__enableTopBorder:(BOOL)enable
{
	if (enable) {
		[self addSubview:[self ul_topBorder]];
	} else {
		[[self ul_topBorder] removeFromSuperview];
	}
}

- (UIView *)ul_topBorder
{
	UIView *topBorder = [self al_associateObjectForSelector:@selector(__topBorderAssociate)];
	
	if (!topBorder) {
		topBorder = [self al_setAssociateObjectWithSelector:@selector(__topBorderAssociate)];
	}
	
	return topBorder;
}

- (UIView *)__topBorderAssociate
{
	CGRect frame = [self rp_frameForPosition:ULBorderTop
								   thickness:[[self class] ul_defaultBorderThickness]
									 padding:[[self class] ul_defaultHorizontalPaddings]];
	UIView *border = [[UIView alloc] initWithFrame:frame];
	border.backgroundColor = [[self class] ul_defaultBorderColor];
	border.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
	
	return border;
}

#pragma mark - Bottom Border

- (void)__enableBottomBorder:(BOOL)enable
{
	if (enable) {
		[self addSubview:[self ul_bottomBorder]];
	} else {
		[[self ul_bottomBorder] removeFromSuperview];
	}
}

- (UIView *)ul_bottomBorder
{
	UIView *bottomBorder = [self al_associateObjectForSelector:@selector(__bottomBorderAssociate)];
	
	if (!bottomBorder) {
		bottomBorder = [self al_setAssociateObjectWithSelector:@selector(__bottomBorderAssociate)];
	}
	
	return bottomBorder;
}

- (UIView *)__bottomBorderAssociate
{
	CGRect frame = [self rp_frameForPosition:ULBorderBottom
								   thickness:[[self class] ul_defaultBorderThickness]
									 padding:[[self class] ul_defaultHorizontalPaddings]];
	UIView *border = [[UIView alloc] initWithFrame:frame];
	border.backgroundColor = [[self class] ul_defaultBorderColor];
	border.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
	
	return border;
}

#pragma mark - Left Border

- (void)__enableLeftBorder:(BOOL)enable
{
	if (enable) {
		[self addSubview:[self ul_leftBorder]];
	} else {
		[[self ul_leftBorder] removeFromSuperview];
	}
}

- (UIView *)ul_leftBorder
{
	UIView *leftBorder = [self al_associateObjectForSelector:@selector(__leftBorderAssociate)];
	
	if (!leftBorder) {
		leftBorder = [self al_setAssociateObjectWithSelector:@selector(__leftBorderAssociate)];
	}
	
	return leftBorder;
}

- (UIView *)__leftBorderAssociate
{
	CGRect frame = [self rp_frameForPosition:ULBorderLeft
								   thickness:[[self class] ul_defaultBorderThickness]
									 padding:[[self class] ul_defaultVerticalPaddings]];
	UIView *border = [[UIView alloc] initWithFrame:frame];
	border.backgroundColor = [[self class] ul_defaultBorderColor];
	border.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin);
	
	return border;
}

#pragma mark - Right Border

- (void)__enableRightBorder:(BOOL)enable
{
	if (enable) {
		[self addSubview:[self ul_rightBorder]];
	} else {
		[[self ul_rightBorder] removeFromSuperview];
	}
}

- (UIView *)ul_rightBorder
{
	UIView *rightBorder = [self al_associateObjectForSelector:@selector(__rightBorderAssociate)];
	
	if (!rightBorder) {
		rightBorder = [self al_setAssociateObjectWithSelector:@selector(__rightBorderAssociate)];
	}
	
	return rightBorder;
}

- (UIView *)__rightBorderAssociate
{
	CGRect frame = [self rp_frameForPosition:ULBorderRight
								   thickness:[[self class] ul_defaultBorderThickness]
									 padding:[[self class] ul_defaultVerticalPaddings]];
	UIView *border = [[UIView alloc] initWithFrame:frame];
	border.backgroundColor = [[self class] ul_defaultBorderColor];
	border.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin);
	
	return border;
}

#pragma mark - Private

- (CGRect)rp_frameForPosition:(UL_BorderPosition)position
					thickness:(CGFloat)thickness
					  padding:(UIEdgeInsets)paddings
{
	CGRect frame = self.bounds;
	
	switch (position) {
		case ULBorderBottom:
			frame.origin.y = self.bounds.size.height - thickness;
		case ULBorderTop:
			frame.size.height = thickness;
			frame.origin.x = paddings.left;
			frame.size.width = self.bounds.size.width - paddings.left - paddings.right;
			break;
			
		case ULBorderRight:
			frame.origin.x = self.bounds.size.width - thickness;
		case ULBorderLeft:
			frame.size.width = thickness;
			frame.origin.y = paddings.top;
			frame.size.height = self.bounds.size.height - paddings.top - paddings.bottom;
			break;
		default:
			break;
	}
	
	return frame;
}

#pragma mark - Default Values

+ (CGFloat)ul_defaultBorderThickness
{
	return 0.5f;
}

+ (UIEdgeInsets)ul_defaultHorizontalPaddings
{
	return UIEdgeInsetsZero;
}

+ (UIEdgeInsets)ul_defaultVerticalPaddings
{
	return UIEdgeInsetsZero;
}

+ (UIColor *)ul_defaultBorderColor
{
	return [UIColor lightGrayColor];
}

@end
