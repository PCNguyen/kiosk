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
#import "RPKNoConnectivityController.h"

#import <Reachability/Reachability.h>

@interface RPKLayoutManager () <RPLocationSelectionViewControllerDelegate>

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
		[RPNotificationCenter registerObject:self
						 forNotificationName:AuthenticationHandlerAuthenticatedNotification
									 handler:@selector(handleAuthenticatedNotification:)
								   parameter:nil];
    }

    return self;
}

- (void)handleAuthenticationNeededNotification:(NSNotification *)notification {
    RPKLoginViewController *loginViewController = [[RPKLoginViewController alloc] init];
    [[RPKLayoutManager rootViewController] presentViewController:loginViewController animated:YES completion:NULL];
}

- (void)handleAuthenticatedNotification:(NSNotification *)notification {
	if ([RPReferenceHandler hasMultiLocation]) {
		RPLocationSelectionViewController *locationSelectionVC = [[RPLocationSelectionViewController alloc] init];
		locationSelectionVC.delegate = self;
		RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:locationSelectionVC];
		[[RPKLayoutManager rootViewController] presentViewController:navigationHolder animated:YES completion:NULL];
	} else {
		[[self menuViewController] validateSources];
	}
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

#pragma mark - LocationSelectionView Delegate

- (void)locationSelectionViewControllerDidDismiss
{
	[self.menuViewController validateSources];
}

- (void)configureReachability
{
	__weak RPKLayoutManager *selfPointer = self;
	
	Reachability *connectivityMonitor = [Reachability reachabilityWithHostName:@"www.google.com"];
	connectivityMonitor.reachableBlock = ^(Reachability *monitor) {
		dispatch_async(dispatch_get_main_queue(), ^{
			UIViewController *presentingViewController = [selfPointer mainNavigationController];
			while ([presentingViewController presentedViewController]) {
				presentingViewController = [presentingViewController presentedViewController];
				if ([presentingViewController isKindOfClass:[RPKNoConnectivityController class]]) {
					[presentingViewController dismissViewControllerAnimated:YES completion:NULL];
				}
			}
		});
	};
	
	connectivityMonitor.unreachableBlock = ^(Reachability *monitor){
		dispatch_async(dispatch_get_main_queue(), ^{
			RPKNoConnectivityController *noConnectivity = [[RPKNoConnectivityController alloc] init];
			UIViewController *presentingViewController = [selfPointer mainNavigationController];
			while ([presentingViewController presentedViewController]) {
				presentingViewController = [presentingViewController presentedViewController];
			}
			
			[presentingViewController presentViewController:noConnectivity animated:YES completion:NULL];
		});
	};
	
	[connectivityMonitor startNotifier];
}

@end
