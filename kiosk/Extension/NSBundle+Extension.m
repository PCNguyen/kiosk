//
//  NSBundle+Extension.m
//  Reputation
//
//  Created by PC Nguyen on 3/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSString *)ns_appVersion
{
	NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	
	return version;
}

+ (NSString *)ns_appBundleID
{
	NSString *bundleID = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
	
	return bundleID;
}

+ (NSString *)ns_appAnalyticName
{
	NSString *bundleName = @"Reputation";
	
	if ([self ns_isFordCustomBuild]) {
		bundleName = @"FD Social";
	}
	
	return bundleName;
}

+ (NSString *)ns_platformID
{
	return @"iOS App";
}

+ (BOOL)ns_isFordCustomBuild
{
	NSString *bundleID = [self ns_appBundleID];
	BOOL isCustomBuild = [bundleID isEqualToString:@"com.reputation.r4e.smb-ford"];
	return isCustomBuild;
}

@end
