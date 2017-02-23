//
//  RPKReachabilityManager.m
//  Kiosk
//
//  Created by PC Nguyen on 2/12/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKReachabilityManager.h"
#import "RPNotificationCenter.h"

#import "AppLibShared.h"
#import <Reachability/Reachability.h>

NSString *const RPKReachabilityChangedNotification = @"RPKReachabilityChangedNotification";

@interface RPKReachabilityManager ()

@property (nonatomic, strong) Reachability *reachabilityMonitor;

@end

@implementation RPKReachabilityManager

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		[self registerNotification];
		[self.reachabilityMonitor startNotifier];
	}
	
	return self;
}

- (Reachability *)reachabilityMonitor
{
	if (!_reachabilityMonitor) {
		_reachabilityMonitor = [Reachability reachabilityWithHostname:@"www.reputation.com"];
	}
	
	return _reachabilityMonitor;
}

- (void)registerNotification
{
	[RPNotificationCenter registerObject:self forNotificationName:kReachabilityChangedNotification handler:@selector(handleReachabilityChangedNotification:) parameter:nil];
}

- (void)handleReachabilityChangedNotification:(NSNotification *)notification
{
	[RPNotificationCenter postNotificationName:RPKReachabilityChangedNotification object:nil];
}

- (BOOL)isReachable
{
	return [self.reachabilityMonitor isReachable];
}

- (void)reset
{
	[self.reachabilityMonitor stopNotifier];
	self.reachabilityMonitor = nil;
	[self.reachabilityMonitor startNotifier];
}

@end
