//
//  NSUserDefaults+DL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSUserDefaults+DL.h"

@implementation NSUserDefaults (DL)

+ (void)dl_saveValue:(id)object forKey:(NSString *)key
{
	[self dl_saveValue:object forKey:key sync:YES];
}

+ (id)dl_loadValueForKey:(NSString *)key
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSData *objectData = [userDefaults objectForKey:key];
	
	id object = nil;
	
	if (objectData.length > 0) {
		object = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
	}
	
	return object;
}

+ (void)dl_saveValue:(id)object forKey:(NSString *)key sync:(BOOL)shouldSync
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	if (object) {
		NSData *objectData = [NSKeyedArchiver archivedDataWithRootObject:object];
		[userDefaults setObject:objectData forKey:key];
	} else {
		[userDefaults removeObjectForKey:key];
	}
	
	if (shouldSync) {
		[userDefaults synchronize];
	}
}

+ (void)dl_wipe
{
	//--avoid itterating through the keys since they might include system keys
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
	[userDefaults removePersistentDomainForName:appDomain];
	[userDefaults synchronize];
	
}

+ (void)dl_wipeExceptKeys:(NSArray *)excludedKeys
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *tempStorage = [NSMutableDictionary dictionary];
	
	//--preserve value in memory
	for (NSString *key in excludedKeys) {
		[tempStorage setValue:[self dl_loadValueForKey:key] forKey:key];
	}
	
	//--wipe
	NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
	[userDefaults removePersistentDomainForName:appDomain];
	
	//--put back saved values
	[tempStorage enumerateKeysAndObjectsUsingBlock:^(NSString *key, id object, BOOL *stop) {
		[userDefaults setObject:object forKey:key];
	}];
	
	[userDefaults synchronize];
}

@end
