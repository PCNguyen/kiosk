//
//  DLStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 10/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLStorage.h"

@interface DLStorage ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation DLStorage

- (instancetype)initWithCache:(NSCache *)cache
{
	if (self = [super init]) {
		_cache = cache;
		_enableCache = YES;
	}
	
	return self;
}

- (NSCache *)cache
{
	if (!_cache) {
		_cache = [[NSCache alloc] init];
		_cache.totalCostLimit = 0;
		_cache.countLimit = 0;
	}
	
	return _cache;
}

- (void)saveCacheObject:(id)object forKey:(NSString *)key
{
	if ([self.cacheDelegate respondsToSelector:@selector(appStorage:saveCacheObject:forKey:)]) {
		[self.cacheDelegate appStorage:self saveCacheObject:object forKey:key];
	} else {
		[[self cache] setObject:object forKey:key cost:1];
	}
}

- (void)removeCacheObjectForKey:(NSString *)key
{
	if ([self.cacheDelegate respondsToSelector:@selector(appStorage:removeCacheObjectForKey:)]) {
		[self.cacheDelegate appStorage:self removeCacheObjectForKey:key];
	} else {
		[[self cache] removeObjectForKey:key];
	}
}

- (void)updateCacheValue:(id)object forKey:(NSString *)key
{
	if (self.enableCache) {
		if (object) {
			[self saveCacheObject:object forKey:key];
		} else {
			[self removeCacheObjectForKey:key];
		}
	}
}

@end
