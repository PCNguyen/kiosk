//
//  RPKLayoutManager.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibShared.h>

#import "RPKLayoutManager.h"
#import "RPKMenuViewController.h"

@interface RPKLayoutManager ()

@property (nonatomic, strong) RPKMenuViewController *menuViewController;

@end

@implementation RPKLayoutManager

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

+ (UIViewController *)rootViewController
{
	return [[self sharedManager] menuViewController];
}

- (RPKMenuViewController *)menuViewController
{
	if (!_menuViewController) {
		_menuViewController = [[RPKMenuViewController alloc] init];
	}
	
	return _menuViewController;
}

@end
