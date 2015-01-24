//
//  RPAttributedLabel.m
//  Reputation
//
//  Created by PC Nguyen on 11/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAttributedLabel.h"
#import "NSAttributedString+RP.h"

@interface RPAttributedLabel ()

@property (nonatomic, strong) NSMutableArray *linkList;

@end

@implementation RPAttributedLabel

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.delegate = self;
	}
	
	return self;
}

- (void)addTextLink:(RPLink *)textLink
{
	if (textLink) {
		NSMutableDictionary *linkStyleAttributes = [NSMutableDictionary dictionaryWithDictionary:textLink.formatAttributes];
		UIColor *linkColor = [linkStyleAttributes objectForKey:NSForegroundColorAttributeName];
		if (linkColor) {
			[linkStyleAttributes setObject:linkColor forKey:(NSString *)kCTForegroundColorAttributeName];
		}
		self.linkAttributes = linkStyleAttributes;
		[self addLinkToURL:textLink.externalLink withRange:[self safeRange:textLink.rangeOffset]];
		[self.linkList addObject:textLink];
	}
}

- (NSMutableArray *)linkList
{
	if (!_linkList) {
		_linkList = [NSMutableArray array];
	}
	
	return _linkList;
}

- (NSRange)safeRange:(NSRange)range
{
	NSString *currentText = self.attributedText.string;
	
	if (range.location >= currentText.length) {
		return NSMakeRange(0, 0);
	}
	
	NSInteger safeLength = range.length;
	
	if (range.location + range.length >= currentText.length) {
		safeLength = currentText.length - range.location;
	}
	
	return NSMakeRange(range.location, safeLength);
}

#pragma mark TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
	for (RPLink *textLink in self.linkList) {
		if ([textLink.externalLink.absoluteString isEqualToString:url.absoluteString]) {
			textLink.linkAction(url);
		}
	}
}

#pragma mark Accessor

- (NSString *)text
{
	return self.attributedText.string;
}

#pragma mark - Override

- (void)tintColorDidChange
{
	/*
	 * Override this so we won't have crash in TTTAttributedLabel
	 **/
	BOOL isInactive = (self.tintAdjustmentMode == UIViewTintAdjustmentModeDimmed);
	
	NSDictionary *attributesToRemove = isInactive ? self.linkAttributes : self.inactiveLinkAttributes;
	NSDictionary *attributesToAdd = isInactive ? self.inactiveLinkAttributes : self.linkAttributes;
	
	NSMutableAttributedString *mutableAttributedString = [self.attributedText mutableCopy];
	for (NSTextCheckingResult *result in self.links) {
		NSRange range = result.range;
		if (range.length + range.location < [self.attributedText.string length]) {
			[attributesToRemove enumerateKeysAndObjectsUsingBlock:^(NSString *name, __unused id value, __unused BOOL *stop) {
				[mutableAttributedString removeAttribute:name range:result.range];
			}];
			
			if (attributesToAdd) {
				[mutableAttributedString addAttributes:attributesToAdd range:result.range];
			}
		}
	}
	
	self.attributedText = mutableAttributedString;
	[self setNeedsDisplay];
}

#pragma mark - RPReusableItem Protocol

- (void)reset
{
	[self setText:nil];
	[self.linkList removeAllObjects];
}

#pragma mark Template

+ (instancetype)detailLabel
{
	RPAttributedLabel *detail = [self plainLabel];
	detail.numberOfLines = 0;
	
	return detail;
}

+ (instancetype)plainLabel
{
	RPAttributedLabel *detail = [[RPAttributedLabel alloc] initWithFrame:CGRectZero];
	detail.backgroundColor = [UIColor clearColor];
	detail.textAlignment = NSTextAlignmentLeft;
	detail.lineBreakMode = NSLineBreakByTruncatingTail;
	detail.font = [UIFont rpk_boldFontWithSize:14.0f];
	detail.textColor = [UIColor blackColor];
	
	return detail;
}

@end
