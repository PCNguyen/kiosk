//
//  NSString+AL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSString+AL.h"

@implementation NSString (AL)

- (NSRange)al_fullRange
{
	NSRange fullRange = NSMakeRange(0, self.length);
	
	return fullRange;
}

- (NSMutableAttributedString *)al_attributedStringWithFont:(UIFont *)font
												 textColor:(UIColor *)color
{
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
	
	UIFont *appliedFont = font;
	
	if (!appliedFont) {
		appliedFont = [UIFont systemFontOfSize:12.0f];
	}
	
	UIColor *appliedColor = color;
	
	if (!appliedColor) {
		appliedColor = [UIColor blackColor];
	}
	
	[attributedString addAttribute:NSFontAttributeName value:appliedFont range:[self al_fullRange]];
	[attributedString addAttribute:NSForegroundColorAttributeName value:appliedColor range:[self al_fullRange]];
	
	return attributedString;
}

@end
