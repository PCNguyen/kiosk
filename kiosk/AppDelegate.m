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

#import <AppSDK/AppLibScheduler.h>

@interface AppDelegate ()

@property (nonatomic, strong) ALScheduledTask *getGuidedAccessTask;
@property (nonatomic, assign) __block NSInteger maxSingleAppAttempt;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	application.idleTimerDisabled = YES;
	[RPKAnalyticEvent configure];
	[RPKCookieHandler clearCookie];
	[self configureLayout];
    [self.window makeKeyAndVisible];

    if (![[RPAccountManager sharedManager] isAuthenticated]) {
		if ([RPAuthenticationHandler canHandleSilentLogin]) {
			[RPAuthenticationHandler silentLogin];
		} else {
			[RPKAnalyticEvent registerSuperProperties];
			[RPNotificationCenter postNotificationName:AuthenticationHandlerAuthenticationRequiredNotification object:nil];
		}
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
	
	return YES;
}

- (void)configureLayout
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[RPKLayoutManager rootViewController]];
}

- (ALScheduledTask *)getGuidedAccessTask
{
	if (!_getGuidedAccessTask) {
		__weak AppDelegate *selfPointer = self;
		_getGuidedAccessTask = [[ALScheduledTask alloc] initWithTaskInterval:2 taskBlock:^{
			selfPointer.maxSingleAppAttempt++;
			if (selfPointer.maxSingleAppAttempt > 5) {
				[selfPointer.getGuidedAccessTask stop];
			}
			
			UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL success) {
				if (success) {
					NSLog(@"Enter Single App Mode");
					[selfPointer.getGuidedAccessTask stop];
				} else {
					NSLog(@"Failed To Get Single Acces");
				}
			});
		}];
	}
	
	return _getGuidedAccessTask;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	self.maxSingleAppAttempt = 0;
	[self.getGuidedAccessTask start];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	UIAccessibilityRequestGuidedAccessSession(NO, ^(BOOL success) {
		if (success) {
			NSLog(@"Exit Single App Mode");
		} else {
			NSLog(@"Failed To Exit Single Acces");
		}
	});
}

@end
