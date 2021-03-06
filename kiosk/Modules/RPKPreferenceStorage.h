//
//  RPReferenceStorage.h
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "DLAppStorage+RP.h"
#import "Mobile.h"

@interface RPKPreferenceStorage : DLAppStorage

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

#pragma mark - Location

/**
 *  get all locations the user authenticated to
 *
 *  @return array of Location objects
 */
- (NSMutableArray *)allLocations;

/**
 *  save the current location for kiosk
 *
 *  @param locationID the location code of the current location
 */
- (void)saveSelectedLocation:(NSString *)locationID;

/**
 *  Load the current location for kiosk
 *
 *  @return the location code of the current location
 */
- (NSString *)loadSelectedLocation;

/**
 *  wrapper to get the selected location
 *
 *  @return Location object
 */
- (Location *)selectedLocation;

@end
