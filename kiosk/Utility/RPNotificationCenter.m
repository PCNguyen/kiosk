//
//  RPNotificationCenter.m
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPNotificationCenter.h"

@implementation RPNotificationCenter

#pragma mark - NSNotificationCenter Wrapper

+ (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

+ (void)postNotificationName:(NSString *)name object:(id)object
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

+ (void)registerObject:(id)object forNotificationName:(NSString *)name handler:(SEL)handler parameter:(id)parameter
{
	[[NSNotificationCenter defaultCenter] removeObserver:object name:name object:parameter];
	[[NSNotificationCenter defaultCenter] addObserver:object selector:handler name:name object:parameter];
}

+ (void)unRegisterObject:(id)object forNotificationName:(NSString *)name parameter:(id)parameter
{
	[[NSNotificationCenter defaultCenter] removeObserver:object name:name object:parameter];
}

+ (void)unRegisterAllNotificationForObject:(id)object
{
	[[NSNotificationCenter defaultCenter] removeObserver:object];
}

@end
