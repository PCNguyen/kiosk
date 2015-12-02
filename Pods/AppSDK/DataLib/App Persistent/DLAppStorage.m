//
//  DLAppStorage.m
//  AppSDK
//
//  Created by PC Nguyen on 10/10/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLAppStorage.h"
#import "NSUserDefaults+DL.h"

@implementation DLAppStorage

- (void)saveValue:(id)value forKey:(NSString *)key
{
	[self updateCacheValue:value forKey:key];
	[NSUserDefaults dl_saveValue:value forKey:key];
}

- (id)loadValueForKey:(NSString *)key
{
	id value = nil;
	
	if (self.enableCache) {
		value = [[self cache] objectForKey:key];
	}
	
	if (!value) {
		value = [NSUserDefaults dl_loadValueForKey:key];
		[self updateCacheValue:value forKey:key];
	}
	
	return value;
}

- (void)wipe
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[NSUserDefaults dl_wipe];
}

- (void)wipeExceptKeys:(NSArray *)excludedKeys
{
	if (self.enableCache) {
		[[self cache] removeAllObjects];
	}
	
	[NSUserDefaults dl_wipeExceptKeys:excludedKeys];
}

@end
