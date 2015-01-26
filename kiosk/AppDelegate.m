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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL success) {
		if (success) {
			NSLog(@"Enter Single App Mode");
		}
	});
	
	[RPKCookieHandler clearCookie];
	[self configureLayout];
    [self.window makeKeyAndVisible];

    if (![[RPAccountManager sharedManager] isAuthenticated]) {
        [RPNotificationCenter postNotificationName:AuthenticationHandlerAuthenticationRequiredNotification object:nil];
    }
	
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
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

@end
