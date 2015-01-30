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
#import "RPKAnalyticEvent.h"
#import "RPKPreferenceStorage.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	application.idleTimerDisabled = YES;
	[RPKAnalyticEvent configure];
	[RPKCookieHandler clearCookie];
	[self configureLayout];
    [self.window makeKeyAndVisible];

    if (![[RPAccountManager sharedManager] isAuthenticated]) {
		[RPKAnalyticEvent registerSuperProperties];
        [RPNotificationCenter postNotificationName:AuthenticationHandlerAuthenticationRequiredNotification object:nil];
	} else {
		RPKPreferenceStorage *preferenceStorage = [[RPKPreferenceStorage alloc] init];
		Location *location = [preferenceStorage selectedLocation];
		if (location) {
			[RPKAnalyticEvent registerSuperPropertiesForUser:[[RPAccountManager sharedManager] userAccount] location:location];
		} else {
			[RPKAnalyticEvent registerSuperPropertiesForUser:[[RPAccountManager sharedManager] userAccount]];
		}
		
		[RPAuthenticationHandler handleAuthenticatedAccount];
	}
	
	[RPKAnalyticEvent sendEvent:AnalyticEventAppLaunch];
	[[RPKLayoutManager sharedManager] configureReachability];
	
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
