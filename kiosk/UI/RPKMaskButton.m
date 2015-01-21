//
//  RPKMaskButton.m
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKMaskButton.h"

@implementation RPKMaskButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if (self.actionBlock) {
		self.actionBlock();
	}
	
	return nil;
}

@end
