//
//  AppDelegate.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "AppDelegate.h"
#import "RPKLayoutManager.h"
#import "RPKCookieHandler.h"
#import "RPAccountManager.h"
#import "RPNotificationCenter.h"
#import "RPAuthenticationHandler.h"

#import <Reachability/Reachability.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	application.idleTimerDisabled = YES;
	
	[RPKCookieHandler clearCookie];
	[self configureLayout];
    [self.window makeKeyAndVisible];

    if (![[RPAccountManager sharedManager] isAuthenticated]) {
        [RPNotificationCenter postNotificationName:AuthenticationHandlerAuthenticationRequiredNotification object:nil];
	} else {
		[RPAuthenticationHandler handleAuthenticatedAccount];
	}
	
	[self configureReachability];
	
	UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL success) {
		if (success) {
			NSLog(@"Enter Single App Mode");
		}
	});

	return YES;
}

- (void)configureLayout
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[RPKLayoutManager rootViewController]];
}

- (void)configureReachability
{
	Reachability *connectivityMonitor = [Reachability reachabilityWithHostName:@"www.google.com"];
	connectivityMonitor.reachableBlock = ^(Reachability *monitor) {
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"Have connectivity");
		});
	};
	
	connectivityMonitor.unreachableBlock = ^(Reachability *monitor){
		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"Don't have connectivity");
		});
	};	
	[connectivityMonitor startNotifier];
}

@end
