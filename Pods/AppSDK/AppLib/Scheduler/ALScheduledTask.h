//
//  ALScheduledTask.h
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ALScheduledTaskHandler)();

@interface ALScheduledTask : NSObject

/**
 *  The task ID
 *	Default to Random NSUUID string
 */
@property (nonatomic, strong) NSString *taskID;

/**
 *  The frequency to carry out task
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 *  Whether or not the task should start immediately
 *	when added to ScheduleManager
 *	default To YES
 */
@property (nonatomic, assign) BOOL startImmediately;

/**
 *  Create a schedule task
 *
 *  @param interval  the time interval task should run
 *  @param taskBlock the task block
 *
 *  @return the task scheduled
 */
- (id)initWithTaskInterval:(NSTimeInterval)interval taskBlock:(ALScheduledTaskHandler)taskBlock;

#pragma mark - Scheduling

/**
 *  start scheduling the task on specified interval. 
 *	Execute the task immediately also
 */
- (void)start;

/**
 *  Start scheduling on specific date with specific interval
 *
 *  @param scheduledDate the date the task will be execute
 */
- (void)startAtDate:(NSDate *)scheduledDate;

/**
 *  stop scheduling the task
 *	this does not interupt the task that is currently executing
 */
- (void)stop;

/**
 *  execute the task immediately, does not affecting any scheduling
 */
- (void)triggerTask;

#pragma mark - Termination Flags

/**
 *  adding a set of notification flags that would terminate the schedule of the task
 *
 *  @param terminationFlags a string array of notification names
 */
- (void)setTerminationFlags:(NSArray *)terminationFlags;

/**
 *  adding a notification flag that terminate the schedule of the task
 *
 *  @param terminationFlag the notification name
 */
- (void)addTerminationFlag:(NSString *)terminationFlag;

/**
 *  removing a notification flag that terminate the schedule of the task
 *
 *  @param terminationFlag the notification name
 */
- (void)removeTerminationFlag:(NSString *)terminationFlag;

#pragma mark - Resume Flags

/**
 *  adding a set of notification flags that would resume the schedule of the task
 *
 *  @param resumeFlags a string array of notification names
 */
- (void)setResumeFlags:(NSArray *)resumeFlags;

/**
 *  adding a notification flag that resume the schedule of the task
 *
 *  @param resumeFlag the notification name
 */
- (void)addResumeFlag:(NSString *)resumeFlag;

/**
 *  removing a notification flag that terminate the schedule of the task
 *
 *  @param resumeFlag the notification name
 */
- (void)removeResumeFlag:(NSString *)resumeFlag;

#pragma mark - Class Helper

/**
 *  a default interval for scheduling task
 */
+ (NSTimeInterval)defaultScheduleInterval;

/**
 *  The default termination flags
 *
 *  @return an array of String representation of Notification Name
 */
+ (NSArray *)defaultTerminationFlags;

/**
 *  The default resume flags
 *
 *  @return an array of String representation of Notification Name
 */
+ (NSArray *)defaultResumeFlags;

@end
