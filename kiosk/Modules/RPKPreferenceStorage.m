//
//  RPReferenceStorage.m
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKPreferenceStorage.h"

#import <AppSDK/AppLibExtension.h>
#import <JNKeychain/JNKeychain.h>

#define kRSUserConfigKey					@"UserConfig"
#define kRSSelectedLocationKey				@"SelectedLocation"

@implementation RPKPreferenceStorage

#pragma mark - Override

- (void)wipe
{
	[self saveUserConfig:nil];
	[self saveSelectedLocation:nil];
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
	
	if ([locationID length] > 0) {
		[JNKeychain saveValue:locationID forKey:kRSSelectedLocationKey];
	} else {
		[JNKeychain deleteValueForKey:kRSSelectedLocationKey];
	}
}

- (NSString *)loadSelectedLocation
{
	NSString *locationCode = [self loadValueForKey:kRSSelectedLocationKey];
	if ([locationCode length] == 0) {
		locationCode = [JNKeychain loadValueForKey:kRSSelectedLocationKey];
	}
	
	return locationCode;
}

- (Location *)selectedLocation
{
	NSString *selectedLocationID = [self loadSelectedLocation];
	NSMutableArray *authLocations = [self loadUserConfig].authLocations;
	
	for (Location *location in authLocations) {
		if ([location.code isEqualToString:selectedLocationID]) {
			return location;
		}
	}
	
	return nil;
}

@end
