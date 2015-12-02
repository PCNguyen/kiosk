//
//  ALScheduledTask.m
//  AppSDK
//
//  Created by PC Nguyen on 10/24/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALScheduledTask.h"

@interface ALScheduledTask ()

@property (readwrite, copy) ALScheduledTaskHandler taskBlock;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableSet *stopFlags;
@property (nonatomic, strong) NSMutableSet *startFlags;
@property (nonatomic, strong) NSDate *stopDate;

@end

@implementation ALScheduledTask

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithTaskInterval:(NSTimeInterval)interval taskBlock:(ALScheduledTaskHandler)taskBlock
{
	if (self = [super init]) {
		_taskID = [[NSUUID UUID] UUIDString];
		_timeInterval = interval;
		_taskBlock = taskBlock;
		_startImmediately = YES;
	}
	
	return self;
}

#pragma mark - Scheduling

- (void)start
{
	[self startAtDate:[NSDate date]];
}

- (void)startAtDate:(NSDate *)scheduledDate
{
	self.timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(triggerTask) userInfo:nil repeats:YES];
	self.timer.fireDate = scheduledDate;
	self.stopDate = nil;
	
	[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stop
{
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
		self.stopDate = [NSDate date];
	}
}

- (void)triggerTask
{
	if (self.taskBlock) {
		self.taskBlock();
	}
}

#pragma mark - Termination Flag

- (NSMutableSet *)stopFlags
{
	if (!_stopFlags) {
		_stopFlags = [NSMutableSet set];
	}
	
	return _stopFlags;
}

- (void)setTerminationFlags:(NSArray *)terminationFlags
{
	//--remove any previous registered notification
	for (NSString *notificationName in self.stopFlags) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
	}
	
	self.stopFlags = [NSMutableSet setWithArray:terminationFlags];
	
	//--adding new notification
	for (NSString *notificationName in self.stopFlags) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTerminationNotification:) name:notificationName object:nil];
	}
}

- (void)addTerminationFlag:(NSString *)terminationFlag
{
	if (![self.stopFlags containsObject:terminationFlag]) {
		[self.stopFlags addObject:terminationFlag];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTerminationNotification:) name:terminationFlag object:nil];
	}
}

- (void)removeTerminationFlag:(NSString *)terminationFlag
{
	if ([self.stopFlags containsObject:terminationFlag]) {
		[self.stopFlags removeObject:terminationFlag];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:terminationFlag object:nil];
	}
}

- (void)handleTerminationNotification:(NSNotification *)notification
{
	[self stop];
}

#pragma mark - Resume Flag

- (NSMutableSet *)startFlags
{
	if (!_startFlags) {
		_startFlags = [NSMutableSet set];
	}
	
	return _startFlags;
}

- (void)setResumeFlags:(NSArray *)resumeFlags
{
	//--remove any previous registered notification
	for (NSString *notificationName in self.startFlags) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
	}
	
	self.startFlags = [NSMutableSet setWithArray:resumeFlags];
	
	//--adding new notification
	for (NSString *notificationName in self.startFlags) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResumeNotification:) name:notificationName object:nil];
	}
}

- (void)addResumeFlag:(NSString *)resumeFlag
{
	if (![self.startFlags containsObject:resumeFlag]) {
		[self.startFlags addObject:resumeFlag];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResumeNotification:) name:resumeFlag object:nil];
	}
}

- (void)removeResumeFlag:(NSString *)resumeFlag
{
	if ([self.startFlags containsObject:resumeFlag]) {
		[self.startFlags removeObject:resumeFlag];
		[[NSNotificationCenter defaultCenter] removeObserver:self name:resumeFlag object:nil];
	}
}

- (void)handleResumeNotification:(NSNotification *)notification
{
	NSTimeInterval timeElapsed = [self.stopDate timeIntervalSinceNow];
	long timeRemain = self.timeInterval + timeElapsed; //--since timeElapse is negative
	
	if (timeRemain <= 0) {
		[self start];
	} else {
		[self startAtDate:[NSDate dateWithTimeIntervalSinceNow:timeRemain]];
	}
	
}

#pragma mark - Class Helpers

+ (NSTimeInterval)defaultScheduleInterval
{
	return 24*60*60;
}

+ (NSArray *)defaultResumeFlags
{
	return @[UIApplicationWillEnterForegroundNotification];
}

+ (NSArray *)defaultTerminationFlags
{
	return @[UIApplicationDidEnterBackgroundNotification];
}

@end
