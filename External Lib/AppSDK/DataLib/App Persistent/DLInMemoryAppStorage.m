//
//  DLTempAppStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 10/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLInMemoryAppStorage.h"
#import "AppLibShared.h"

@interface DLInMemoryAppStorage ()

@property (nonatomic, strong) NSMutableDictionary *dataStore;

@end

@implementation DLInMemoryAppStorage

+ (instancetype)sharedInstance
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] initWithCache:nil];
	});
}

- (instancetype)initWithCache:(NSCache *)cache
{
	if (self = [super init]) {
		self.enableCache = NO; //--we don't need caching for inmmemory data
	}
	
	return self;
}

#pragma mark - Data Structure

- (NSMutableDictionary *)dataStore
{
	if (!_dataStore) {
		_dataStore = [NSMutableDictionary dictionary];
	}
	
	return _dataStore;
}

#pragma mark - Override

- (void)saveValue:(id)value forKey:(NSString *)key
{
	[self.dataStore setValue:value forKey:key];
}

- (id)loadValueForKey:(NSString *)key
{
	return [self.dataStore valueForKey:key];
}

- (void)wipe
{
	self.dataStore = nil;
}

- (void)wipeExceptKeys:(NSArray *)excludedKeys
{
	NSArray *allKeys = [NSArray arrayWithArray:[self.dataStore allKeys]];
	
	for (NSString *key in allKeys) {
		if (![excludedKeys containsObject:key]) {
			[self.dataStore setValue:nil forKey:key];
		}
	}
}

@end
