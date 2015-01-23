//
//  RPReferenceStorage.m
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKPreferenceStorage.h"

#import <AppSDK/AppLibExtension.h>

#define kRSUserConfigKey					@"UserConfig"
#define kRSSelectedLocationKey				@"SelectedLocation"

@implementation RPKPreferenceStorage

#pragma mark - Override

- (void)wipe
{
	[self saveUserConfig:nil];
}

#pragma mark - Preference

- (void)saveUserConfig:(UserConfig *)userConfig
{
	[self saveValue:userConfig forKey:kRSUserConfigKey];
}

- (UserConfig *)loadUserConfig
{
	UserConfig *userConfig = (UserConfig *)[self loadValueForKey:kRSUserConfigKey];
	
	return userConfig;
}

#pragma mark - Location

- (NSMutableArray *)allLocations
{
	return [self loadUserConfig].authLocations;
}

- (void)saveSelectedLocation:(NSString *)locationID
{
	[self saveValue:locationID forKey:kRSSelectedLocationKey];
}

- (NSString *)loadSelectedLocation
{
	NSString *locationCode = [self loadValueForKey:kRSSelectedLocationKey];
	
	return locationCode;
}

@end
