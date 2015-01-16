//
//  UIButton+RP.m
//  Reputation
//
//  Created by PC Nguyen on 7/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIButton+RP.h"
#import "UIColor+RP.h"
#import "UIFont+RP.h"
#import <AppSDK/AppLibExtension.h>
#import <AppSDK/UILibExtension.h>

@implementation UIButton (RP)

+ (instancetype)rp_buttonWithIcon:(UIImage *)icon
							title:(NSAttributedString *)title
				  backgroundColor:(UIColor *)backgroundColor
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[customButton setImage:icon forState:UIControlStateNormal];
	[customButton setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, kUIButtonImageSpacing)];
	[customButton setAttributedTitle:title forState:UIControlStateNormal];
	[customButton setBackgroundColor:backgroundColor];
	
	return customButton;
}

+ (instancetype)rp_blueButtonWithTitle:(NSString *)title
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rp_boldFontWithSize:16.0f] textColor:[UIColor whiteColor]];
	NSAttributedString *attributedSelectedTitle = [title al_attributedStringWithFont:[UIFont rp_boldFontWithSize:16.0f] textColor:[UIColor ul_colorWithR:255 G:255 B:255 A:0.5f]];
	[customButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[customButton setAttributedTitle:attributedSelectedTitle forState:UIControlStateHighlighted];
	[customButton setBackgroundColor:[UIColor rp_brightBlue]];
	
	return customButton;
}

- (void)rp_setTitleLocations:(NSArray *)locations
{
	NSString *title = [locations al_objectAtIndex:0];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rp_boldFontWithSize:12.0f]
																   textColor:[UIColor rp_locationTextColor]];
	if ([locations count] > 1) {
		title = [NSString stringWithFormat:@"%d Locations", [locations count]];
		attributedTitle = [title al_attributedStringWithFont:[UIFont rp_boldFontWithSize:12.0f]
												   textColor:[UIColor rp_linkTextColor]];
	}
	
	[self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

- (void)rp_setTitleLocationCount:(NSInteger)count
{
	NSString *title = [NSString stringWithFormat:@"%d Locations", count];
	
	if (count == 1) {
		title =	[NSString stringWithFormat:@"%d Location", count];
	}
	
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rp_boldFontWithSize:12.0f]
																   textColor:[UIColor rp_linkTextColor]];
	
	[self setAttributedTitle:attributedTitle forState:UIControlStateNormal];
}

@end
