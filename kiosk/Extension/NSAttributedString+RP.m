//
//  NSAttributedString+RP.m
//  Reputation
//
//  Created by PC Nguyen on 7/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "NSAttributedString+RP.h"
#import "RPKUIKit.h"
#import <AppSDK/AppLibExtension.h>

@implementation NSAttributedString (RP)

+ (NSMutableAttributedString *)rp_attributedDescriptionFromText:(NSString *)descriptionText
{
	return [descriptionText al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:14.0f]
											  textColor:[UIColor blackColor]];
}

+ (NSMutableAttributedString *)rp_attributedSubratingTitle:(NSString *)subRatingTitle
{
	return [subRatingTitle al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:14.0f]
											 textColor:[UIColor rpk_mediumGray]];
}

- (void)rp_addLineSpacing:(CGFloat)lineHeight
{
	[self rp_addLineSpacing:lineHeight lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)rp_addLineSpacing:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:lineHeight];
	[paragraphStyle setLineBreakMode:lineBreakMode];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	
	if ([self isKindOfClass:[NSMutableAttributedString class]]) {
		[(NSMutableAttributedString *)self addAttribute:NSParagraphStyleAttributeName
												  value:paragraphStyle
												  range:[self.string al_fullRange]];
	}
}

@end
