//
//  RPReferenceHandler.h
//  Reputation
//
//  Created by PC Nguyen on 4/23/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RPNetworkHandler.h"
#import "RPKPreferenceStorage.h"

@interface RPReferenceHandler : RPNetworkHandler

#pragma mark - UserConfig

/**
 *  fetch UserConfig from remote and refresh local copy,
 *	return a completion block
 *	and also firing notification to observer
 *
 */
+ (void)getUserConfig;

/**
 *  save user config locally
 *
 *  @param userConfig the current UserConfig
 */
+ (void)saveUserConfig:(UserConfig *)userConfig;


#pragma mark - Locations

/**
 *  determine if a tenant is authorized for single location or multiple locations
 *
 *  @return YES if multilocation, NO otherwise
 */
+ (BOOL)hasMultiLocation;

/**
 *  authenticated locations for user
 *
 *  @return array of Location objects
 */
+ (NSMutableArray *)authenticatedLocations;

/**
 *  all locations that has social post features enabled
 *
 *  @return array of Location objects
 */
+ (NSArray *)postEnabledLocations;

/**
 *  return the first location in a multi-location environment, or the single location
 *
 *  @return a Location object
 */
+ (Location *)firstLocation;

/**
 *  a union set of all enabled social sites at specific locations
 *
 *  @param locations the locations that need check
 *
 *  @return an array of NSString representation of unique social sites 'ID
 */
+ (NSArray *)allowedSocialSitesAtLocations:(NSArray *)locations;

#pragma mark - Permission

/**
 *  Determine if the user has access permission for certain modules
 *
 *  @param permission the permission string in MobileCommonConstants, e.g. DASHBOARD_ENABLED
 *
 *  @return YES if permission include, NO otherwise
 */
+ (BOOL)hasPermission:(NSString *)permission;

@end
