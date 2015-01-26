//
//  RPScheduleHandler.m
//  Reputation
//
//  Created by PC Nguyen on 11/20/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <AppSDK/AppLibShared.h>
#import <AppSDK/AppLibScheduler.h>

#import "RPScheduleHandler.h"
#import "RPReferenceHandler.h"


#define kSHDataInterval						24*60*60
#define kSHConfigInterval					60

@implementation RPScheduleHandler

+ (void)scheduleAllServices
{
	[self scheduleOnInterval:kSHConfigInterval immediateStart:NO task:^{
		[RPReferenceHandler getUserConfig];
	}];
}

+ (void)unScheduleAllServices
{
	[[self localScheduler] unScheduleAllTasks];
}

+ (void)scheduleOnInterval:(NSTimeInterval)timeInterval immediateStart:(BOOL)immediateStart task:(void (^)())taskBlock
{
	ALScheduledTask *scheduledTask = [[ALScheduledTask alloc] initWithTaskInterval:timeInterval taskBlock:taskBlock];
	scheduledTask.startImmediately = immediateStart;
	
	[scheduledTask setTerminationFlags:[ALScheduledTask defaultTerminationFlags]];
	[scheduledTask setResumeFlags:[ALScheduledTask defaultResumeFlags]];
	
	[[self localScheduler] scheduleTask:scheduledTask];
}

+ (ALScheduleManager *)localScheduler
{
	SHARE_INSTANCE_BLOCK(^{
		return [[ALScheduleManager alloc] init];
	});
}

+ (void)triggerAllServices
{
	for (ALScheduledTask *scheduledTask in [[self localScheduler] allScheduledTasks]) {
		[scheduledTask triggerTask];
	}
}

@end
