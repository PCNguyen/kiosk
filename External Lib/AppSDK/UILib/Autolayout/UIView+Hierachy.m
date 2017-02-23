//
//  UIView+Hierachy.m
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIView+Hierachy.h"

@implementation UIView (Hierachy)

- (NSArray *)__superviews
{
	NSMutableArray *array = [NSMutableArray array];
	UIView *view = self.superview;
	while (view) {
		[array addObject:view];
		view = view.superview;
	}
	
	return array;
}

- (BOOL)__isAncestorOfView:(UIView *)view
{
	return [[view __superviews] containsObject:self];
}

- (UIView *)ul_nearestCommonAncestorToView:(UIView *)view
{
	// Check for same view
	if ([self isEqual:view]) {
		return self;
	}
	
	// Check for direct superview relationship
	if ([self __isAncestorOfView:view]) {
		return self;
	}
	
	if ([view __isAncestorOfView:self]) {
		return view;
	}
	
	// Search for indirect common ancestor
	NSArray *ancestors = [self __superviews];
	for (UIView *superView in [view __superviews]) {
		if ([ancestors containsObject:superView]) {
			return superView;
		}
	}
	
	// No common ancestor
	return nil;
}

@end
