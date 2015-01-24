//
//  RPLink.m
//  Reputation
//
//  Created by PC Nguyen on 11/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPLink.h"

@implementation RPLink

- (instancetype)initWithLink:(NSURL *)externalLink range:(NSRange)rangeOffset
{
	if (self = [super init]) {
		_externalLink = externalLink;
		_rangeOffset = rangeOffset;
		
		__weak UIApplication *application = [UIApplication sharedApplication];
		_linkAction = ^(NSURL *linkURL){
			[application openURL:linkURL];
		};
	}
	
	return self;
}

- (instancetype)initWithLink:(NSURL *)externalLink offset:(NSInteger)offset length:(NSInteger)length
{
	NSRange rangeOffset = NSMakeRange(0, 0);
	if (offset >= 0 && length >= 0) {
		rangeOffset = NSMakeRange(offset, length);
	}
	
	if (self = [self initWithLink:externalLink range:rangeOffset]) {}
	return self;
}

- (NSDictionary *)formatAttributes
{
	if (!_formatAttributes) {
		_formatAttributes = @{NSForegroundColorAttributeName: [UIColor rpk_defaultBlue],
							  NSFontAttributeName: [UIFont rpk_extraBoldFontWithSize:16.0f]};
	}
	
	return _formatAttributes;
}

@end
