//
//  UIView+LayoutPosition.m
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIView+LayoutPosition.h"

@implementation UIView (LayoutPosition)

#pragma mark - Configure

- (void)ul_enableAutoLayout
{
	self.translatesAutoresizingMaskIntoConstraints = NO;
}
- (void)ul_disableAutoLayout
{
	self.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)ul_tightenContentWithPriority:(UILayoutPriority)priority
{
	[self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
	[self setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
	[self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
	[self setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - Sizing

- (NSMutableArray *)ul_fixedSize:(CGSize)size
{
	NSMutableArray *constraints = [self ul_fixedSize:size priority:UILayoutPriorityRequired];
	
	return constraints;
}

- (NSMutableArray *)ul_fixedSize:(CGSize)size priority:(UILayoutPriority)priority
{
	NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[view(==width)]"
																		options:0
																		metrics:@{@"width":@(size.width)}
																		  views:@{@"view":self}];
	NSArray *heightConstraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==height)]"
																		options:0
																		metrics:@{@"height":@(size.height)}
																		  views:@{@"view":self}];
	
	NSMutableArray *sizeArray = [NSMutableArray array];
	[sizeArray addObjectsFromArray:widthConstraints];
	[sizeArray addObjectsFromArray:heightConstraint];
	
	for (NSLayoutConstraint *constraint in sizeArray) {
		constraint.priority = priority;
	}
	
	[self addConstraints:sizeArray];
	
	return sizeArray;
}

- (NSMutableArray *)ul_matchSizeOfView:(UIView *)view ratio:(CGSize)sizeRatio
{
	NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
																	   attribute:NSLayoutAttributeWidth
																	   relatedBy:NSLayoutRelationEqual
																		  toItem:view
																	   attribute:NSLayoutAttributeWidth
																	  multiplier:sizeRatio.width
																		constant:0.0f];
	NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self
																		attribute:NSLayoutAttributeHeight
																		relatedBy:NSLayoutRelationEqual
																		   toItem:view
																		attribute:NSLayoutAttributeHeight
																	   multiplier:sizeRatio.height
																		 constant:0.0f];
	
	NSMutableArray *sizeArray = [NSMutableArray arrayWithObjects:widthConstraint, heightConstraint, nil];
	
	return sizeArray;
}

#pragma mark - Alignment

- (NSMutableArray *)ul_horizontalAlign:(NSLayoutFormatOptions)alignmentOption
						   withView:(UIView *)siblingView
						   distance:(NSInteger)distance
						leftToRight:(BOOL)isLeftToRight
{
	return [self __alignDirection:@"H"
				alignmentOption:alignmentOption
					   withView:siblingView
					   distance:distance
				   naturalOrder:isLeftToRight];
}

- (NSMutableArray *)ul_verticalAlign:(NSLayoutFormatOptions)alignmentOption
						 withView:(UIView *)siblingView
						 distance:(NSInteger)distance
					  topToBottom:(BOOL)isTopToBottom
{
	return [self __alignDirection:@"V"
				alignmentOption:alignmentOption
					   withView:siblingView
					   distance:distance
				   naturalOrder:isTopToBottom];
}

- (NSMutableArray *)ul_centerAlignWithView:(UIView *)view
{
	NSLayoutConstraint *horizontalConstraint = [self ul_centerAlignWithView:view direction:@"H"];
	NSLayoutConstraint *verticalConstraint = [self ul_centerAlignWithView:view direction:@"V"];
	NSMutableArray *allignmentArray = [NSMutableArray arrayWithObjects:horizontalConstraint, verticalConstraint, nil];
	
	return allignmentArray;
}

- (NSLayoutConstraint *)ul_centerAlignWithView:(UIView *)view direction:(NSString *)direction
{
	NSLayoutAttribute attribute = NSLayoutAttributeCenterX;
	
	if ([direction isEqualToString:@"H"]) {
		attribute = NSLayoutAttributeCenterY;
	}
	
	NSLayoutConstraint *layoutConstraint = [NSLayoutConstraint constraintWithItem:self
																		attribute:attribute
																		relatedBy:NSLayoutRelationEqual
																		   toItem:view
																		attribute:attribute
																	   multiplier:1.0f
																		 constant:0.0f];
	return layoutConstraint;
}

#pragma mark - Containment

- (NSMutableArray *)ul_pinWithInset:(UIEdgeInsets)inset
{
	NSArray *topConstraint = [self __constraintsForPinDistance:inset.top direction:@"V" naturalOrder:YES];
	NSArray *bottomConstraint = [self __constraintsForPinDistance:inset.bottom direction:@"V" naturalOrder:NO];
	NSArray *leftConstraint = [self __constraintsForPinDistance:inset.left direction:@"H" naturalOrder:YES];
	NSArray *rightConstraint = [self __constraintsForPinDistance:inset.right direction:@"H" naturalOrder:NO];
	
	NSMutableArray *alignmentArray = [NSMutableArray array];
	[alignmentArray addObjectsFromArray:topConstraint];
	[alignmentArray addObjectsFromArray:bottomConstraint];
	[alignmentArray addObjectsFromArray:leftConstraint];
	[alignmentArray addObjectsFromArray:rightConstraint];
	return alignmentArray;
}

#pragma mark - Adding Constraint

- (void)ul_addConstraints:(NSMutableArray *)constraints priority:(UILayoutPriority)priority
{
	for (NSLayoutConstraint *constraint in constraints) {
		constraint.priority = priority;
	}
	
	[self addConstraints:constraints];
}

#pragma mark - Private

- (NSMutableArray *)__alignDirection:(NSString *)direction
				   alignmentOption:(NSLayoutFormatOptions)alignmentOption
						  withView:(UIView *)siblingView
						  distance:(NSInteger)distance
					  naturalOrder:(BOOL)isNaturalOrder
{
	NSString *spacer = @"-";
	NSString *firstView =@"view";
	NSString *secondView = @"otherView";
	
	NSDictionary *metrics = nil;
	
	if (distance != kUIViewAquaDistance) {
		spacer = @"-distance-";
		metrics = @{@"distance":@(distance)};
	}
	
	if (!isNaturalOrder) {
		firstView = @"otherView";
		secondView = @"view";
	}
	
	NSString *formatLayout = [NSString stringWithFormat:@"%@:[%@]%@[%@]",direction, firstView, spacer, secondView];
	NSArray *layouts = [NSLayoutConstraint constraintsWithVisualFormat:formatLayout
															   options:alignmentOption
															   metrics:metrics
																 views:@{@"view":self, @"otherView":siblingView}];
	
	NSMutableArray *alignmentArray = [NSMutableArray arrayWithArray:layouts];
	return alignmentArray;
}

- (NSArray *)__constraintsForPinDistance:(NSInteger)distance
							 direction:(NSString *)direction
						  naturalOrder:(BOOL)isNaturalOrder
{
	NSArray *layoutConstraint = [NSArray array];
	
	if (distance != kUIViewUnpinInset) {
		NSString *spacer = @"-";
		NSString *firstView = @"|";
		NSString *secondView = @"[view]";
		NSDictionary *metrics = nil;
		
		if (distance != kUIViewAquaDistance) {
			spacer = @"-distance-";
			metrics = @{@"distance":@(distance)};
		}
		
		if (!isNaturalOrder) {
			firstView = @"[view]";
			secondView = @"|";
		}
		
		NSString *formatLayout = [NSString stringWithFormat:@"%@:%@%@%@", direction, firstView, spacer, secondView];
		layoutConstraint = [NSLayoutConstraint constraintsWithVisualFormat:formatLayout
																   options:0
																   metrics:metrics
																	 views:@{@"view": self}];
	}
	
	return layoutConstraint;
}

@end
