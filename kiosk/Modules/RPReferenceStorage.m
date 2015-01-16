//
//  RPReferenceStorage.m
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPReferenceStorage.h"

#import <AppSDK/AppLibExtension.h>

#define kRPReferenceStorageUserConfigKey					@"UserConfig"

#define kRPReferenceStorageSelectedSourcesInfoKey			@"SelectedSourcesInfo"

@implementation RPReferenceStorage

#pragma mark - Override

- (void)wipe
{
	[self saveUserConfig:nil];
	[self saveDashboardCustomSites:nil];
}

#pragma mark - Preference

- (void)saveUserConfig:(UserConfig *)userConfig
{
	[self saveValue:userConfig forKey:kRPReferenceStorageUserConfigKey];
}

- (UserConfig *)loadUserConfig
{
	UserConfig *userConfig = (UserConfig *)[self loadValueForKey:kRPReferenceStorageUserConfigKey];
	
	return userConfig;
}

#pragma mark - UserSettings

- (void)saveUserSettings:(NSMutableArray *)userSettings
{
	UserConfig *userConfig = [self loadUserConfig];
	userConfig.userSettings = userSettings;
	[self saveUserConfig:userConfig];
}

- (NSMutableArray *)loadUserSettings
{
	NSMutableArray *userSettings = [self loadUserConfig].userSettings;
	
	return userSettings;
}

- (void)updateUserSetting:(UserPreference *)setting
{
	UserConfig *userConfig = [self loadUserConfig];
	NSMutableArray *updatedSettings = [NSMutableArray array];
	
	[userConfig.userSettings enumerateObjectsUsingBlock:^(UserPreference *existSetting, NSUInteger index, BOOL *stop) {
		if (![existSetting.preferenceId isEqualToString:setting.preferenceId]) {
			[updatedSettings addObject:existSetting];
		}
	}];
	
	[updatedSettings addObject:setting];
	userConfig.userSettings = updatedSettings;
	
	[self saveUserConfig:userConfig];
}

- (void)updateUserSettings:(NSArray *)settings
{
	UserConfig *userConfig = [self loadUserConfig];
	NSMutableArray *updatedSettings = [NSMutableArray array];
	NSMutableArray *updatedIDs = [NSMutableArray array];
	
	for (UserPreference *preference in settings) {
		if (preference.preferenceId.length > 0) {
			[updatedIDs addObject:preference.preferenceId];
			[updatedSettings addObject:preference];
		}
	}
	
	for (UserPreference *userPreference in userConfig.userSettings) {
		if (![updatedIDs containsObject:userPreference.preferenceId]) {
			[updatedSettings addObject:userPreference];
		}
	}
	
	userConfig.userSettings = updatedSettings;
	[self saveUserConfig:userConfig];
}

- (UserPreference *)loadUserSettingForID:(NSString *)settingID
{
	NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"preferenceId == %@",settingID];
	NSArray *matchedSettings = [[self loadUserSettings] filteredArrayUsingPredicate:idPredicate];
	UserPreference *userSetting = [matchedSettings al_objectAtIndex:0];
	
	if (!userSetting) {
		userSetting = [UserPreference new];
		userSetting.preferenceId = settingID;
	}
	
	return userSetting;
}

- (NSArray *)loadUserSettingsForIDs:(NSArray *)settingIDs
{
	NSMutableArray *matchedSettings = [NSMutableArray array];
	
	for (NSString *settingID in settingIDs) {
		[matchedSettings addObject:[self loadUserSettingForID:settingID]];
	}
	
	return matchedSettings;
}

#pragma mark - Filter

- (NSArray *)allDateRangeOptions
{
	NSArray *facetOptions = [self loadUserConfig].dateRanges.facetOptions;
	return facetOptions;
}

- (NSArray *)allSentimentOptions
{
	NSArray *facetOptions = [self loadUserConfig].sentimentValues.facetOptions;
	return facetOptions;
}

- (NSArray *)allSocialStateOptions
{
	NSArray *facetOptions = [self loadUserConfig].socialStates.facetOptions;
	return facetOptions;
}


#pragma mark - Sources

- (NSArray *)allReviewSites
{
	NSArray *facetOptions = [self loadUserConfig].reviewSources.facetOptions;
	return facetOptions;
}

- (NSArray *)allSocialSites
{
	NSArray *facetOptions = [self loadUserConfig].socialSources.facetOptions;
	
	return facetOptions;
}

- (NSArray *)allIndustryDefaultSites
{
	NSArray *facetOptions = [self loadUserConfig].industrySources.facetOptions;
	
	return facetOptions;
}

- (void)saveDashboardCustomSites:(NSArray *)sites
{
	[self saveValue:sites forKey:kRPReferenceStorageSelectedSourcesInfoKey];
}

- (NSArray *)loadDashboardCustomSites
{
	NSArray *customSourcesInfo = (NSArray *)[self loadValueForKey:kRPReferenceStorageSelectedSourcesInfoKey];
	return customSourcesInfo;
}

- (void)saveCustomizedDashboardSites:(NSArray *)sites
{
	NSString *customDashboardID = [MobileCommonConstants PREFERENCE_DASHBOARD_SOURCE_CUSTOMIZED];
	UserPreference *customDashboardSettings = [self loadUserSettingForID:customDashboardID];
	customDashboardSettings.selectedValues = [NSMutableArray arrayWithArray:sites];
	[self updateUserSetting:customDashboardSettings];
}

- (NSArray *)loadCustomizedDashboardSites
{
	UserPreference *customDashboardSettings = [self loadUserSettingForID:[MobileCommonConstants PREFERENCE_DASHBOARD_SOURCE_CUSTOMIZED]];
	
	return customDashboardSettings.selectedValues;
}

#pragma mark - Location

- (NSMutableArray *)allLocations
{
	return [self loadUserConfig].authLocations;
}

@end
