//
//  RPKLayoutManager.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "AppLibShared.h"

#import "RPKLayoutManager.h"
#import "RPKNavigationController.h"
#import "RPAuthenticationHandler.h"
#import "RPKNoConnectivityController.h"
#import "RPKReachabilityManager.h"
#import "RPNotificationCenter.h"

#import <Reachability/Reachability.h>

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

#pragma mark - Reachbility

- (void)configureReachability
{
	[RPNotificationCenter registerObject:self
					 forNotificationName:RPKReachabilityChangedNotification
								 handler:@selector(handleReachabilityChangedNotification:)
							   parameter:nil];
	[RPKReachabilityManager sharedManager];
}

- (void)handleReachabilityChangedNotification:(NSNotification *)notification
{
	[self toggleNoConnectivityScreen];
}

- (void)toggleNoConnectivityScreen
{
	if ([[RPKReachabilityManager sharedManager] isReachable]) {
		UIViewController *presentingViewController = [self mainNavigationController];
		while ([presentingViewController presentedViewController]) {
			presentingViewController = [presentingViewController presentedViewController];
			if ([presentingViewController isKindOfClass:[RPKNoConnectivityController class]]) {
				[presentingViewController dismissViewControllerAnimated:YES completion:NULL];
			}
		}
	} else {
		RPKNoConnectivityController *noConnectivity = [[RPKNoConnectivityController alloc] init];
		noConnectivity.administratorDelegate = self.menuViewController;
		UIViewController *presentingViewController = [self mainNavigationController];
		while ([presentingViewController presentedViewController]) {
			presentingViewController = [presentingViewController presentedViewController];
		}
		
		if (![presentingViewController isKindOfClass:[RPKNoConnectivityController class]]) {
			[presentingViewController presentViewController:noConnectivity animated:YES completion:NULL];
		}
	}
}

@end
