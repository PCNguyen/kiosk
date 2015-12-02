//
//  DLAppStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

@interface DLAppStorage : DLStorage

/**
 *  Save specific value for key, nil to remove the previous value
 *	Will also save to cache if cache is enabled
 *	Saving nil will remove persistent and cache object for the particular key
 *
 *  @param value the object to be saved
 *  @param key   the key to identifi the object
 */
- (void)saveValue:(id)value forKey:(NSString *)key;

/**
 *  load the previous saved value, 
 *	if cache is enable, it will load from cache first
 *
 *  @param key the key to identify the object
 *
 *  @return the object in cache or persisted object if cache not exist
 */
- (id)loadValueForKey:(NSString *)key;

/**
 *  wipe the persistent store
 */
- (void)wipe;

/**
 *  wipe the persistent store except excluded keys
 *
 *  @param excludedKeys the keys not to be wiped
 */
- (void)wipeExceptKeys:(NSArray *)excludedKeys;

@end
