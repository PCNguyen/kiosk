//
//  RPReferenceHandler.m
//  Reputation
//
//  Created by PC Nguyen on 4/23/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPReferenceHandler.h"

#import "RPNetworkManager.h"
#import "RPScheduleHandler.h"

#import "SearchFilter+RP.h"
#import "UserPreference+RP.h"

#import <AppSDK/UILibDataBinding.h>
#import <AppSDK/AppLibExtension.h>

NSString *const RPReferenceHandlerNetworkActivityBeginNotification = @"RPReferenceHandlerNetworkActivityBeginNotification";
NSString *const RPReferenceHandlerNetworkActivityCompleteNotification = @"RPReferenceHandlerNetworkActivityCompleteNotification";

@implementation RPReferenceHandler

#pragma mark - Override

+ (NSString *)activityBeginNotificationName
{
	return RPReferenceHandlerNetworkActivityBeginNotification;
}

+ (NSString *)activityCompleteNotificationName
{
	return RPReferenceHandlerNetworkActivityCompleteNotification;
}

#pragma mark - User Config

+ (void)getUserConfig
{
	RPReferenceServiceConfigCompletion configCompletion = ^(BOOL success, NSError *error, UserConfig *userConfig) {
		if (success) {
			[self saveUserConfig:userConfig];
		}
		[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceGetUserConfig]];
		[self postNetworkActivityCompleteNotificationForService:ServiceGetUserConfig error:error];
	};
	
	[self postNetworkActivityBeginNotificationForService:ServiceGetUserConfig];
	[[RPNetworkManager referenceService] getUserConfigWithCompletion:configCompletion];
}

+ (void)saveUserConfig:(UserConfig *)userConfig
{
	RPReferenceStorage *referenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	[referenceStorage saveUserConfig:userConfig];
}

+ (void)wipePreferenceData
{
	RPReferenceStorage *referenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	[referenceStorage wipe];
}

#pragma mark - Locations

+ (BOOL)hasMultiLocation
{
	BOOL multipleLocation = NO;
	
	if ([[self authenticatedLocations] count] > 1) {
		multipleLocation = YES;
	}
	
	return multipleLocation;
}

+ (NSMutableArray *)authenticatedLocations
{
	RPReferenceStorage *preferenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	NSMutableArray *authLocations = [preferenceStorage allLocations];
	
	return authLocations;
}

+ (NSArray *)postEnabledLocations
{
	//--TODO: change to using predicate
	NSMutableArray *aggregatedLocations = [NSMutableArray array];
	
	for (Location *location in [self authenticatedLocations]) {
		if ([location.socialSitesPostEnabled count] > 0) {
			[aggregatedLocations addObject:location];
		}
	}
	
	return aggregatedLocations;
}

+ (Location *)firstLocation
{
	return [[self authenticatedLocations] al_objectAtIndex:0];
}


+ (NSArray *)allowedSocialSitesAtLocations:(NSArray *)locations
{
	NSMutableArray *aggregatedSources = [NSMutableArray array];
	
	for (Location *location in [self authenticatedLocations]) {
		if ([locations containsObject:location.code]) {
			NSArray *socialSources = location.socialSitesPostEnabled;
			for (NSString *socialSource in socialSources) {
				if (![aggregatedSources containsObject:socialSources]) {
					[aggregatedSources addObject:socialSource];
				}
			}
		}
	}
	
	return aggregatedSources;
}

#pragma mark - Permission

+ (BOOL)hasPermission:(NSString *)permission
{
	RPReferenceStorage *storage = [RPReferenceStorage sharedCacheAppStorage];
	NSArray *permissions = [storage loadUserConfig].featuresEnabled;
	BOOL enable = [permissions containsObject:permission];
	
	return enable;
}

@end
