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

#pragma mark - User Settings

+ (void)sendNotificationSettings:(NSMutableArray *)notificationPreferences
{
	//--comparing previous hash
	RPReferenceStorage *preferenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	__block BOOL hasChange = NO;
	[notificationPreferences enumerateObjectsUsingBlock:^(UserPreference *notificationSetting, NSUInteger index, BOOL *stop){
		UserPreference *existingPreference = [preferenceStorage loadUserSettingForID:notificationSetting.preferenceId];
		hasChange = ![[existingPreference rp_hash] isEqualToString:[notificationSetting rp_hash]];
		*stop = hasChange;
	}];
	
	if (hasChange) {
		//--update local
		[preferenceStorage updateUserSettings:notificationPreferences];
		
		//--notify dataSource
		[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceUpdateNotificationSetting] error:nil];
		
		//--update remote
		[[RPNetworkManager referenceService] updateUserSettings:[preferenceStorage loadUserSettings]
													 completion:^(BOOL success, NSError *error, NSArray *items, long long count) {}];
	}
}

+ (void)sendLocationSettings:(NSMutableArray *)locationIDs
{
	RPReferenceStorage *preferenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	NSString *locationSettingsID = [MobileCommonConstants PREFERENCE_GENERAL_LOCATION];
	UserPreference *locationPreference = [preferenceStorage loadUserSettingForID:locationSettingsID];
	
	//--taking previous hash
	NSString *previousHash = [locationPreference rp_hash];
	
	//--assign selected locations and hash out
	locationPreference.selectedValues = [NSMutableArray arrayWithObject:[MobileCommonConstants LOCATIONS_ALL]];

	[[preferenceStorage allLocations] enumerateObjectsUsingBlock:^(Location *location, NSUInteger index, BOOL *stop) {
		if (![locationIDs containsObject:location.code]) {
			locationPreference.selectedValues = locationIDs;
			*stop = YES;
		}
	}];
	
	NSString *currentHash = [locationPreference rp_hash];
	
	if (![currentHash isEqualToString:previousHash]) {
		
		//--local update
		[preferenceStorage updateUserSetting:locationPreference];
		
		//--remote update
		AppServiceDataCompletion updateCompletion = ^(BOOL success, NSError *error, NSArray *items, long long count) {
			if (!error) {
				[RPScheduleHandler triggerAllServices];
			}
		};
		
		[[RPNetworkManager referenceService] updateUserSettings:[preferenceStorage loadUserSettings] completion:updateCompletion];
	}
}

+ (void)sendDashboardSettings:(NSMutableArray *)siteIDs
{
	RPReferenceStorage *preferenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	NSString *dashboardSettingsID = [MobileCommonConstants PREFERENCE_DASHBOARD_SOURCE_CUSTOMIZED];
	UserPreference *dashboardSettings = [preferenceStorage loadUserSettingForID:dashboardSettingsID];

	//--take the hash of previous values
	NSString *previousHash = [dashboardSettings rp_hash];
	
	//--update new settings
	dashboardSettings.selectedValues = siteIDs;
	
	//--recompute the hash to see if changes are neccesary
	if (![[dashboardSettings rp_hash] isEqualToString:previousHash]) {
		
		//--update local
		[preferenceStorage updateUserSetting:dashboardSettings];
		
		//--refresh UI
		[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceUpdateDashboardSetting]];
		
		//--update remote
		[[RPNetworkManager referenceService] updateUserSettings:[preferenceStorage loadUserSettings]
													 completion:^(BOOL success, NSError *error, NSArray *items, long long count) {}];
	}
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

#pragma mark - Dashboard Customization

+ (PreferenceDashboardType)dashboardType
{
	RPReferenceStorage *storage = [RPReferenceStorage sharedCacheAppStorage];
	NSArray *customSources = [storage loadCustomizedDashboardSites];
	PreferenceDashboardType dashboardType = ([customSources count] > 0 ? DashboardTypeCustom : DashboardTypeDefault);
	
	return dashboardType;
}

@end
