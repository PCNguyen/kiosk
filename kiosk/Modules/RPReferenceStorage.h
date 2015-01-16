//
//  RPReferenceStorage.h
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "DLAppStorage+RP.h"
#import "Mobile.h"

typedef enum {
	DashboardTypeDefault,
	DashboardTypeCustom,
} PreferenceDashboardType;

@interface RPReferenceStorage : DLAppStorage

#pragma mark - Preference

/**
 *  save userConfig to persistent store, also updating cache
 *
 *  @param userConfig the updated userConfig
 */
- (void)saveUserConfig:(UserConfig *)userConfig;

/**
 *  load the entire userConfig from cache, or persistent store if cache does not exist
 *
 *  @return userConfig representation of particular user
 */
- (UserConfig *)loadUserConfig;

#pragma mark - User Settings

/**
 *  update the user settings in UserConfig
 *
 *  @param userSettings array of UserPreference objects
 */
- (void)saveUserSettings:(NSMutableArray *)userSettings;

/**
 *  a list of saved settings for the user
 *
 *  @return array of UserPreference objects
 */
- (NSMutableArray *)loadUserSettings;

/**
 *  update the specific setting in UserConfig, leave other settings inact
 *
 *  @param setting the updated setting
 */
- (void)updateUserSetting:(UserPreference *)setting;

/**
 *  update specific settings in UserConfig, leave other settings inact
 *
 *  @param settings array of UserPreference object
 */
- (void)updateUserSettings:(NSArray *)settings;

/**
 *  retrieve the user settings based on specific id
 *
 *  @param settingID the setting id (e.g. [MobileCommonContstant PREFERENCE_DASHBOARD_SOURCE_CUSTOMIZED])
 *
 *  @return a UserPreference that match the key or a new instance if that preference not exist
 */
- (UserPreference *)loadUserSettingForID:(NSString *)settingID;

/**
 *  retrieve the user settings that matched the setting IDs
 *
 *  @param settingIDs array of string representation of setting ids
 *
 *  @return an array of UserPreference objects
 */
- (NSArray *)loadUserSettingsForIDs:(NSArray *)settingIDs;

#pragma mark - Filters

/**
 *  all date range options stored in UserConfig
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allDateRangeOptions;

/**
 *  all sentiments options stored in UserConfig
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allSentimentOptions;

/**
 *  all social states options stored in UserConfig
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allSocialStateOptions;

#pragma mark - Sites

/**
 *  all review sites stored in UserConfig
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allReviewSites;

/**
 *  all social sites stored in UserConfig
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allSocialSites;

/**
 *  all default sites for the tenant based on industry
 *
 *  @return array of FacetOptions
 */
- (NSArray *)allIndustryDefaultSites;

/**
 *  save the customize dashboard sites
 *
 *  @param sites array of String representation of site IDs
 */
- (void)saveCustomizedDashboardSites:(NSArray *)sites;

/**
 *  load the customtized dashboard sites
 *
 *  @param sites array of String representation of site IDs
 */
- (NSArray *)loadCustomizedDashboardSites;

#pragma mark - Locations

/**
 *  all locations this users are authenticated to
 *
 *  @return array of Location objects
 */
- (NSMutableArray *)allLocations;

@end
