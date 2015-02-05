//
//  RPKMaskButton.m
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKMaskButton.h"

@interface RPKMaskButton ()

/**
 *  To guard against double tap
 */
@property (nonatomic, strong) NSDate *lastHit;

@end

@implementation RPKMaskButton

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.lastHit = [NSDate date];
	}
	
	return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	BOOL inBound = CGRectContainsPoint(self.bounds, point);
	BOOL doubleTapGuarded = ABS([self.lastHit timeIntervalSinceNow]) > 1;
	self.lastHit = [NSDate date];
	
	if (self.actionBlock && self.isActive && inBound && doubleTapGuarded) {
		self.actionBlock();
	}
	
	return nil;
}

@end
