//
//  RPKLayoutManager.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibShared.h>

#import "RPKLayoutManager.h"
#import "RPKNavigationController.h"
#import "RPKLoginViewController.h"
#import "Mobile.h"
#import "RPNotificationCenter.h"

NSString *const RPKLayoutManagerAuthenticationNeededNotification = @"RPKLayoutManagerAuthenticationNeededNotification";

@interface RPKLayoutManager ()

@property (nonatomic, strong) RPKNavigationController *mainNavigationController;

@end

@implementation RPKLayoutManager

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

- (void)dealloc
{
    [RPNotificationCenter removeObserver:self forKeyPath:RPKLayoutManagerAuthenticationNeededNotification];
}

- (instancetype)init {
    if (self = [super init]) {
        [RPNotificationCenter registerObject:self
                         forNotificationName:RPKLayoutManagerAuthenticationNeededNotification
                                     handler:@selector(handleAuthenticationNeededNotification:)
                                   parameter:nil];
    }
}

- (void)handleAuthenticationNeededNotification:(NSNotification *)notification {
    RPKLoginViewController *loginViewController = [[RPKLoginViewController alloc] init];
    [[RPKLayoutManager rootViewController] presentViewController:loginViewController animated:YES completion:NULL];
}

+ (UIViewController *)rootViewController
{
	return [[self sharedManager] mainNavigationController];
}

- (RPKMenuViewController *)menuViewController
{
	if (!_menuViewController) {
		_menuViewController = [[RPKMenuViewController alloc] init];
	}
	
	return _menuViewController;
}

- (RPKNavigationController *)mainNavigationController
{
	if (!_mainNavigationController) {
		_mainNavigationController = [[RPKNavigationController alloc] initWithRootViewController:self.menuViewController];
	}
	
	return _mainNavigationController;
}

@end
