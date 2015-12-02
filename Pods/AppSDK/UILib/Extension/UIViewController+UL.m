//
//  UIViewController+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIViewController+UL.h"
#import "UIDevice+Compatibility.h"

@implementation UIViewController (UL)

- (void)ul_adjustIOS7Boundaries
{
	if ([UIDevice al_compatibleWithMajorVersion:7]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
}

- (BOOL)ul_isActive
{
	BOOL isActive = self.isViewLoaded && self.view.window;
	return isActive;
}

@end
