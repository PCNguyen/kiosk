//
//  NSLayoutConstraint+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSLayoutConstraint+UL.h"
#import "UIView+Hierachy.h"

@implementation NSLayoutConstraint (UL)

- (void)ul_remove
{
	if ([self __isUnary]) {
		[[self __firstView] removeConstraint:self];
	} else {
		UIView *view = [[self __firstView] ul_nearestCommonAncestorToView:[self __secondView]];
		
		if (view) {
			[view removeConstraint:self];
		}
	}
}

- (UIView *)__firstView
{
	return (UIView *)self.firstItem;
}

- (UIView *)__secondView
{
	return (UIView *)self.secondItem;
}

- (BOOL)__isUnary
{
	return ([self __secondView] == nil);
}

@end
