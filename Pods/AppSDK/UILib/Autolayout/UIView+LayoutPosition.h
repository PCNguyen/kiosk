//
//  UIView+LayoutPosition.h
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger kUIViewAquaDistance	= -2;
static NSInteger kUIViewUnpinInset		= -1;

@interface UIView (LayoutPosition)

#pragma mark - Configure

/**
 *  Enable autolayout by disabling autoResizingMask
 */
- (void)ul_enableAutoLayout;

/**
 *  Disable autolayout by enabling autoResizingMask
 */
- (void)ul_disableAutoLayout;

/**
 *  Set priority for both contentHugging and contentCompressiong on both axis
 *
 *  @param priority priority for contentHugging and contentCompressing
 */
- (void)ul_tightenContentWithPriority:(UILayoutPriority)priority;

#pragma mark - Sizing

/**
 *  Install Size Constraints on this view
 *
 *  @param size the desired size of the view
 *
 *  @return the list of NSLayoutConstraint that has been installed on this view
 */
- (NSMutableArray *)ul_fixedSize:(CGSize)size;

/**
 *  Install Size Constraints on this view with preset priority
 *
 *  @param size     the desired size of the view
 *  @param priority priority for sizing constraints
 *
 *  @return the list of NSLayoutConstraint that has been installed on this view
 */
- (NSMutableArray *)ul_fixedSize:(CGSize)size priority:(UILayoutPriority)priority;

/**
 *  Create constraints that will match the size of this view with another view with a specific ratio
 *
 *  @param view      the other view
 *  @param sizeRatio the ratio between this view and the other view
 *
 *  @return the list of NSLayoutConstraint to be installed
 */
- (NSMutableArray *)ul_matchSizeOfView:(UIView *)view ratio:(CGSize)sizeRatio;

#pragma mark - Alignment

/**
 *  Create constraints that will horizontally align this view with another view based on specific options
 *
 *  @param alignmentOption the alignment options (e.g. base, top, centerX, ...)
 *  @param siblingView     the other view
 *  @param distance        the horizontal spacing between the this view and the other views
 *  @param isLeftToRight   whether this view is on the left or on the right of the other view
 *
 *  @return the list of NSLayoutConstraint to be installed
 */
- (NSMutableArray *)ul_horizontalAlign:(NSLayoutFormatOptions)alignmentOption
						   withView:(UIView *)siblingView
						   distance:(NSInteger)distance
						leftToRight:(BOOL)isLeftToRight;

/**
 *  Create constraints that will vertically align this view with another view based on specific options
 *
 *  @param alignmentOption the alignment options (e.g. leading, trailing, centerY, ...)
 *  @param siblingView     the other view
 *  @param distance        the vertical spacing between this view and the other views
 *  @param isTopToBottom   wheter this view is on top or on the bottom of the other view
 *
 *  @return the list of NSLayoutConstraint to be installed
 */
- (NSMutableArray *)ul_verticalAlign:(NSLayoutFormatOptions)alignmentOption
						 withView:(UIView *)siblingView
						 distance:(NSInteger)distance
					  topToBottom:(BOOL)isTopToBottom;

/**
 *  Create constraints that will match this view's center with another view's center for both dimension
 *
 *  @param view the other view
 *
 *  @return the list of NSLayoutConstraint to be installed
 */
- (NSMutableArray *)ul_centerAlignWithView:(UIView *)view;

/**
 *  Create constraints that will align this view's center with another view's center on specific dimension
 *
 *  @param view      the other view
 *  @param direction the dimension to align ("H" for horizontal and "V" for vertical)
 *
 *  @return the NSLayoutConstraint to be installed
 */
- (NSLayoutConstraint *)ul_centerAlignWithView:(UIView *)view direction:(NSString *)direction;

#pragma mark - Containment

/**
 *  pin this view inside another view with specific spacing on each side
 *
 *  @param inset the spacing between each side of this view to the side of the parent view.
 *
 *  @return the list of NSLayoutConstraint to be installed
 */
- (NSMutableArray *)ul_pinWithInset:(UIEdgeInsets)inset;

#pragma mark - Adding Constraint

/**
 *  install a constraint lists with specific priority on this view
 *
 *  @param constraints the list of NSLayoutContraint objects
 *  @param priority    the priority to install them with
 */
- (void)ul_addConstraints:(NSMutableArray *)constraints priority:(UILayoutPriority)priority;

@end
