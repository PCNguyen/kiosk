//
//  UINavigationBar+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UINavigationBar+UL.h"
#import "UIDevice+Compatibility.h"

@implementation UINavigationBar (UL)

- (void)ul_setBarSolidColor:(UIColor *)color
{
	[self setBackgroundColor:color];
	[self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
	[self setShadowImage:[[UIImage alloc] init]];
	
	if ([UIDevice al_matchMajorVersion:6]) {
		[self setTintColor:color];
	} else {
		[self setBarTintColor:color];
	}
}

@end
