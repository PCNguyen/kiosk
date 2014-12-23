//
//  RPKCookieHandler.m
//  kiosk
//
//  Created by PC Nguyen on 12/23/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKCookieHandler.h"

@implementation RPKCookieHandler

+ (void)clearCookie
{
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
