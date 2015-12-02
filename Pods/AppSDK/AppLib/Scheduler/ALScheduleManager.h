//
//  ALScheduleManager.h
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALScheduledTask.h"

@interface ALScheduleManager : NSObject

/**
 *  Set the default time interval for every scheduled task block
 *	This does not affect when the ALScheduledTask is created manually
 *	Default to be 24 hours
 */
@property (nonatomic, assign) NSTimeInterval defaultTimeInterval;

/**
 *  Set the default termination flags for every scheduled task block
 *	This does not affect when the ALScheduledTask is created manually
 *	Default to be UIApplicationDidEnterBackgroundNotification
 */
@property (nonatomic, strong) NSArray *defaultTerminationFlags;

/**
 *  Set the default resume flags for every scheduled task block
 *	This does not affect when ALScheduledTask is created manually
 *	Default to be UIApplicationWillEnterForegroundNotification
 */
@property (nonatomic, strong) NSArray *defaultResumeFlags;

/**
 *  access the share instance
 *
 *  @return the shared instance
 */
+ (instancetype)sharedManager;

#pragma mark - Scheduling

/**
 *  convenient way to schedule a task block with default configuration
 *
 *  @param taskBock the task to be scheduled
 *
 *  @return the ALScheduledTask object with taskID
 */
- (ALScheduledTask *)scheduleTaskBlock:(void (^)())taskBock;

/**
 *  Schedule a custom scheduled task
 *
 *  @param task the task to be scheduled
 */
- (void)scheduleTask:(ALScheduledTask *)task;

#pragma mark - Unscheduling

/**
 *  Unscheduled a task with the ID that match existing task
 *
 *  @param taskID the taskID to be unscheduled
 */
- (void)unScheduleTaskID:(NSString *)taskID;

/**
 *  Unschedule all registered task
 */
- (void)unScheduleAllTasks;

#pragma mark - Accessing

/**
 *  Direct access to a scheduled task based on ID
 *
 *  @param taskID the task ID to search
 *
 *  @return the task
 */
- (ALScheduledTask *)scheduledTaskForID:(NSString *)taskID;

/**
 *  Direct access to all current scheduled task
 *
 *  @return an array of ALScheduledTask
 */
- (NSArray *)allScheduledTasks;

@end
