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
#import "RPNotificationCenter.h"
#import "RPAuthenticationHandler.h"
#import "RPLocationSelectionViewController.h"
#import "RPReferenceHandler.h"

@interface RPKLayoutManager () <RPKLoginViewControllerDelegate>

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
    [RPNotificationCenter unRegisterObject:self forNotificationName:AuthenticationHandlerAuthenticationRequiredNotification parameter:nil];
}

- (instancetype)init {
    if (self = [super init]) {
        [RPNotificationCenter registerObject:self
                         forNotificationName:AuthenticationHandlerAuthenticationRequiredNotification
                                     handler:@selector(handleAuthenticationNeededNotification:)
                                   parameter:nil];
    }

    return self;
}

- (void)handleAuthenticationNeededNotification:(NSNotification *)notification {
    RPKLoginViewController *loginViewController = [[RPKLoginViewController alloc] init];
	loginViewController.delegate = self;
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

#pragma mark - Login View Controller Delegate

- (void)loginViewControllerDidDismissed
{
	if ([RPReferenceHandler hasMultiLocation]) {
		RPLocationSelectionViewController *locationSelectionVC = [[RPLocationSelectionViewController alloc] init];
		RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:locationSelectionVC];
		[[RPKLayoutManager rootViewController] presentViewController:navigationHolder animated:YES completion:NULL];
	}
}

@end
