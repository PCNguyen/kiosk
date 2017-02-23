//
//  ALSafeOperation.m
//  AppSDK
//
//  Created by PC Nguyen on 11/18/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALSafeOperation.h"

typedef enum {
	ALOperationPausedState = -1,
	ALOperationCancelState = 0,
	ALOperationReadyState = 1,
	ALOperationExecutingState = 2,
	ALOperationFinishedState = 3
} ALOperationState;

static inline NSString * ALKeyPathFromOperationState(ALOperationState state) {
	switch (state) {
		case ALOperationReadyState:
			return @"isReady";
		case ALOperationExecutingState:
			return @"isExecuting";
		case ALOperationFinishedState:
			return @"isFinished";
		case ALOperationPausedState:
			return @"isPaused";
		case ALOperationCancelState:
			return @"isCancelled";
		default:
			return @"unknownState";
	}
}

static NSString *const kALOperationLockName      = @"com.sdk.operation.lock";

@interface ALSafeOperation ()

@property (nonatomic, assign) ALOperationState state;
@property (nonatomic, strong, readonly) NSRecursiveLock *lock;
@property (nonatomic, assign) BOOL shouldTerminate;

@end

@implementation ALSafeOperation

- (id)init
{
	if (self = [super init]) {
		_state = ALOperationReadyState;
		
		_lock = [[NSRecursiveLock alloc] init];
		_lock.name = [self operationLockName];
		
		_shouldTerminate = NO;
	}
	
	return self;
}

#pragma mark - Operation Life Cycle

- (void)start
{
	[self.lock lock];
	
	self.state = ALOperationExecutingState;
	
	if (self.shouldTerminate) {
		[self cancel];
	} else {
		[self operationDidExecute];
	}
	
	[self.lock unlock];
}

- (void)pause
{
	[self.lock lock];
	
	if (![self isPaused] && ![self isCancelled] && ![self isFinished]) {
		if ([self respondsToSelector:@selector(operationWillPause)]) {
			[self operationWillPause];
		}
		self.state = ALOperationPausedState;
	}
	
	[self.lock unlock];
}

- (void)resume
{
	[self.lock lock];
	
	if ([self isPaused]) {
		self.state = ALOperationExecutingState;
		if ([self respondsToSelector:@selector(operationDidResume)]) {
			[self operationDidResume];
		}
	}
	
	[self.lock unlock];
}

- (void)cancel
{
	[self.lock lock];
	
	if (![self isFinished] && ![self isCancelled]) {
		if ([self respondsToSelector:@selector(operationWillCancel)]) {
			[self operationWillCancel];
		}
		self.state = ALOperationCancelState;
		self.state = ALOperationFinishedState; //--so that operation can be removed from the queue
	}
	
	[self.lock unlock];
}

- (void)finish
{
	[self.lock lock];
	
	if (![self isFinished] && ![self isCancelled]) {
		if ([self respondsToSelector:@selector(operationWillFinish)]) {
			[self operationWillFinish];
		}
		self.state = ALOperationFinishedState;
	}
	
	[self.lock unlock];
}

- (void)terminate {
	if ([self isExecuting]) {
		[self cancel];
	} else {
		self.shouldTerminate = YES;
	}
}

#pragma - State Helper

- (void)setState:(ALOperationState)state {
	[self.lock lock];
	
	BOOL isPaused = [self isPaused];
	BOOL isCancelled = [self isCancelled];
	
	dispatch_sync(dispatch_get_main_queue(), ^{
		switch (state) {
			case ALOperationExecutingState:
				[self evaluateExecutingState:isPaused];
				break;
				
			case ALOperationPausedState:
				if ([self respondsToSelector:@selector(changeStateToPause)]) {
					[self changeStateToPause];
				}
				break;
				
			case ALOperationCancelState:
				if ([self respondsToSelector:@selector(changeStateToCancel)]) {
					[self changeStateToCancel];
				}
				break;
				
			case ALOperationFinishedState:
				[self evaluateFinishState:isCancelled];
				break;
				
			default:
				break;
		}
	});
	
	NSString *oldStateKey = ALKeyPathFromOperationState(self.state);
	NSString *newStateKey = ALKeyPathFromOperationState(state);
	
	[self willChangeValueForKey:newStateKey];
	[self willChangeValueForKey:oldStateKey];
	
	_state = state;
	
	if ([self isCancelled]) {
		[super cancel];
	}
	
	[self didChangeValueForKey:oldStateKey];
	[self didChangeValueForKey:newStateKey];
	
	[self.lock unlock];
}

#pragma mark - Accessors

- (BOOL)isReady
{
	return ([self state] == ALOperationReadyState);
}

- (BOOL)isExecuting
{
	return ([self state] == ALOperationExecutingState);
}

- (BOOL)isFinished
{
	return ([self state] == ALOperationFinishedState);
}

- (BOOL)isCancelled
{
	return ([self state] == ALOperationCancelState);
}

- (BOOL)isPaused
{
	return ([self state] == ALOperationPausedState);
}

#pragma mark - Accessor For Subclass

- (BOOL)isConcurrent
{
	return NO;
}

- (BOOL)isAsynchronous
{
	return NO;
}

- (NSString *)operationLockName {
	return kALOperationLockName;
}

#pragma mark - Private Operation Handling

- (void)evaluateExecutingState:(BOOL)isPaused
{
	if (isPaused) {
		if ([self respondsToSelector:@selector(resumeStateToExecuting)]) {
			[self resumeStateToExecuting];
		}
	} else {
		if ([self respondsToSelector:@selector(changeStateToExecuting)]) {
			[self changeStateToExecuting];
		}
	}
}

- (void)evaluateFinishState:(BOOL)isCancelled
{
	if (!isCancelled) {
		if ([self respondsToSelector:@selector(changeStateToFinish)]) {
			[self changeStateToFinish];
		}
	}
}

#pragma mark - ALOperation Protocol

- (void)operationDidExecute
{
	[self finish];
	
	/* Subclas Should Override If Needed */
}

- (void)operationWillPause
{
	/* Subclas Should Override If Needed */
}

- (void)operationDidResume
{
	[self finish];
	
	/* Subclas Should Override If Needed */
}

- (void)operationWillCancel
{
	/* Subclas Should Override If Needed */
}

- (void)operationWillFinish
{
	/* Subclas Should Override If Needed */
}

- (void)changeStateToExecuting
{
	/* Subclas Should Override If Needed */
}

- (void)changeStateToPause
{
	/* Subclas Should Override If Needed */
}

- (void)resumeStateToExecuting
{
	/* Subclas Should Override If Needed */
}

- (void)changeStateToCancel
{
	/* Subclas Should Override If Needed */
}

- (void)changeStateToFinish
{
	/* Subclas Should Override If Needed */
}

@end
