//
//  AppDelegate.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "AppDelegate.h"
#import "RPKLayoutManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self configureLayout];
	[self.window makeKeyAndVisible];
	return YES;
}

- (void)configureLayout
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:[RPKLayoutManager rootViewController]];
}

@end
