//
//  NSBundle+RPK.m
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "NSBundle+RPK.h"

@implementation NSBundle (RPK)

+ (NSString *)rpk_serverURL
{
	return [self rpk_infoPlistValueForKey:@"Server URL"];
}

+ (id)rpk_infoPlistValueForKey:(NSString *)key
{
	return [[self mainBundle] objectForInfoDictionaryKey:key];
}

@end
