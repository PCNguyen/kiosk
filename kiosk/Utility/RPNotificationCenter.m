//
//  RPNotificationCenter.m
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPNotificationCenter.h"

#pragma mark - Process Notification

NSString *const RPNotificationCenterAuthenticatedNotification			= @"RPNotificationCenterAuthenticatedNotification";
NSString *const RPNotificationCenterAuthenticationRequiredNotification	= @"RPNotificationCenterAuthenticationRequiredNotification";
NSString *const RPNotificationCenterLogoutNotification					= @"RPNotificationCenterLogoutNotification";

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

#pragma mark - App Notification

+ (void)postAuthenticationRequiredNotification
{
	[self postNotificationName:RPNotificationCenterAuthenticationRequiredNotification object:nil];
}

+ (void)postAuthenticatedNotification
{
	[self postNotificationName:RPNotificationCenterAuthenticatedNotification object:nil];
}

+ (void)postLogoutNotification
{
	[self postLogoutNotification:nil];
}

+ (void)postLogoutNotification:(id)object
{
	[self postNotificationName:RPNotificationCenterLogoutNotification object:object];
}

@end
