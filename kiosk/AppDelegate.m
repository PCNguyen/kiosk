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
#import "RPReferenceHandler.h"

#import <AppSDK/AppLibScheduler.h>

@interface AppDelegate ()

@property (nonatomic, assign) BOOL appLaunch;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	application.idleTimerDisabled = YES;
	
	//--uncomment this if we need to clear keychain
//	[RPAuthenticationHandler wipeAccount];
//	[RPReferenceHandler wipePreferenceData];
	
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

	self.appLaunch = YES;
	return YES;
}

- (void)configureLayout
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[RPKLayoutManager rootViewController]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	self.appLaunch = YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	if (self.appLaunch) {
		[self performSelector:@selector(aquireSingleAppMode) withObject:self afterDelay:3];
	}
}

- (void)aquireSingleAppMode
{
	UIAccessibilityRequestGuidedAccessSession(YES, ^(BOOL success) {
		if (success) {
			NSLog(@"Enter Single App Mode");
			self.appLaunch = NO;
		} else {
			NSLog(@"Failed To Get Single Acces");
		}
	});
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
