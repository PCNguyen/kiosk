//
//  UIBarButtonItem+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIBarButtonItem+UL.h"
#import "UIDevice+Compatibility.h"

@implementation UIBarButtonItem (UL)

+ (instancetype)ul_barButtonItemWithImage:(UIImage *)image
								   target:(id)target
								   action:(SEL)action
{
	UIBarButtonItem *barButtonItem = nil;
	
	if ([UIDevice al_matchMajorVersion:6]) {
		UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[imageButton setImage:image forState:UIControlStateNormal];
		[imageButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
		
		imageButton.frame = (CGRect){CGPointZero, CGSizeMake(44.0f, 44.0f)};
		barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];

	} else {
		barButtonItem = [[UIBarButtonItem alloc] initWithImage:image
														 style:UIBarButtonItemStylePlain
														target:target
														action:action];
	}
	
	return barButtonItem;
}

@end
