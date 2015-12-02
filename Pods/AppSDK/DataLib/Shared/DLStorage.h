//
//  DLStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLStorage;

@protocol DLStorageCacheDelegate <NSObject>

@optional

/**
 *  provide an entry point to custom save cache object with calculating cost
 *	default to save to cache without cost calculation
 *
 *  @param storage the appStorage
 *  @param object  the object to be saved to cache
 *  @param key     the key to identify the object
 */
- (void)appStorage:(DLStorage *)storage saveCacheObject:(id)object forKey:(NSString *)key;

/**
 *  provide an entry point to custom remove cache object
 *
 *  @param storage the appStorage
 *  @param key     the key to identify the object
 */
- (void)appStorage:(DLStorage *)storage removeCacheObjectForKey:(NSString *)key;

@end

@interface DLStorage : NSObject

/**
 *  if cache is disable, object are written directly to persistent store
 *	default is YES if a cache is provided with initWithCache:
 */
@property (nonatomic, assign) BOOL enableCache;

/**
 *  Enable custom cache handling
 */
@property (nonatomic, weak) id<DLStorageCacheDelegate>cacheDelegate;

/**
 *  construct a storage with a cache
 *
 *  @param cache the cache to store data
 *
 *  @return instance of DLStorage
 */
- (instancetype)initWithCache:(NSCache *)cache;

/**
 *  lazy created a cache if one is not provided in the constructor
 *	the default cache created will have maximum cost and limit
 *
 *  @return the interal cache for storage
 */
- (NSCache *)cache;

/**
 *  save object to cache
 *
 *  @param object the object need to save
 *  @param key    the object identifier
 */
- (void)saveCacheObject:(id)object forKey:(NSString *)key;

/**
 *  Remove cache object
 *
 *  @param key the object identifier
 */
- (void)removeCacheObjectForKey:(NSString *)key;

/**
 *  Convenient way to update cache value with cache enable check and removal check
 *	This will do NOTHING if cache is NOT ENABLE
 *
 *  @param object the value to update
 *  @param key    the key to update
 */
- (void)updateCacheValue:(id)object forKey:(NSString *)key;

@end
