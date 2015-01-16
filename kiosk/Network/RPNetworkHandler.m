//
//  RPNetworkHandler.m
//  Reputation
//
//  Created by PC Nguyen on 5/16/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPNetworkHandler.h"
#import "RPNotificationCenter.h"

#import <AppSDK/AppLibShared.h>
#import <AppSDK/UILibDataBinding.h>

NSString *const RPNetworkHandlerActivityBeginNotification = @"RPNetworkHandlerActivityBeginNotification";
NSString *const RPNetworkHandlerActivityCompleteNotification = @"RPNetworkHandlerActivityCompleteNotification";

@implementation RPNetworkHandler

#pragma mark - Notification

+ (void)addObserverForNetworkActivityBegin:(id)observer selector:(SEL)selector
{
	[RPNotificationCenter registerObject:observer
					 forNotificationName:[[self class] activityBeginNotificationName]
								 handler:selector
							   parameter:nil];
}

+ (void)removeObserverForNetworkActivityBegin:(id)observer
{
	[RPNotificationCenter unRegisterObject:observer
					   forNotificationName:[[self class] activityBeginNotificationName]
								 parameter:nil];
}

+ (void)addObserverForNetworkActivityComplete:(id)observer selector:(SEL)selector
{
	[RPNotificationCenter registerObject:observer
					 forNotificationName:[[self class] activityCompleteNotificationName]
								 handler:selector
							   parameter:nil];
}

+ (void)removeObserverForNetworkActivityComplete:(id)observer
{
	[RPNotificationCenter unRegisterObject:observer
					   forNotificationName:[[self class] activityCompleteNotificationName]
								 parameter:nil];
}

+ (void)postNetworkActivityBeginNotificationForService:(RPServiceType)serviceType
{
	[RPNotificationCenter postNotificationName:[[self class] activityBeginNotificationName]
									  userInfo:[RPService userInfoForServiceType:serviceType]];
}

+ (void)postNetworkActivityCompleteNotificationForService:(RPServiceType)serviceType error:(NSError *)error
{
	[RPNotificationCenter postNotificationName:[[self class] activityCompleteNotificationName]
									  userInfo:[RPService userInfoForServiceType:serviceType error:error]];
}

#pragma mark - Threading

+ (NSOperationQueue *)sharedQueue
{
	SHARE_INSTANCE_BLOCK(^{
		NSOperationQueue *operationQueue = [NSOperationQueue new];
		operationQueue.maxConcurrentOperationCount = 1;
		return operationQueue;
	});
}

+ (void)serializeBlock:(void (^)())block
{
	[[self sharedQueue] addOperationWithBlock:block];
}

+ (void)notifyDataSourceForService:(RPServiceType)serviceType error:(NSError *)error
{
	dispatch_sync(dispatch_get_main_queue(), ^{
		[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:serviceType]
																  error:error];
	});
}

+ (void)safelyComplete:(NetworkHandlerCompletion)completion withError:(NSError *)error
{
	if (completion) {
		completion(error);
	}
}

#pragma mark - Subclass Hook

+ (NSString *)activityBeginNotificationName
{
	return RPNetworkHandlerActivityBeginNotification;
}

+ (NSString *)activityCompleteNotificationName
{
	return RPNetworkHandlerActivityCompleteNotification;
}

@end
