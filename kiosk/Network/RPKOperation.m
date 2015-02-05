//
//  SDOperation.m
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKOperation.h"

typedef enum {
	RPKOperationPausedState = -1,
    RPKOperationCancelState = 0,
	RPKOperationReadyState = 1,
	RPKOperationExecutingState = 2,
	RPKOperationFinishedState = 3
} RPKOperationState;

static inline NSString * SDKeyPathFromOperationState(RPKOperationState state) {
	switch (state) {
		case RPKOperationReadyState:
			return @"isReady";
		case RPKOperationExecutingState:
			return @"isExecuting";
		case RPKOperationFinishedState:
			return @"isFinished";
		case RPKOperationPausedState:
			return @"isPaused";
        case RPKOperationCancelState:
            return @"isCancelled";
		default:
			return @"unknownState";
	}
}

static NSString *const kSDOperationLockName      = @"com.sdk.operation.lock";

@interface RPKOperation ()

@property (nonatomic, assign) RPKOperationState state;
@property (nonatomic, strong, readonly) NSRecursiveLock *lock;
@property (nonatomic, assign) BOOL shouldTerminate;

@end

@implementation RPKOperation

- (id)init
{
    if (self = [super init]) {
        _state = RPKOperationReadyState;
        
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
    
	self.state = RPKOperationExecutingState;
	
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
		self.state = RPKOperationPausedState;
    }
    
    [self.lock unlock];
}

- (void)resume
{
    [self.lock lock];
    
    if ([self isPaused]) {
        self.state = RPKOperationExecutingState;
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
        self.state = RPKOperationCancelState;
        self.state = RPKOperationFinishedState; //--so that operation can be removed from the queue
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
		self.state = RPKOperationFinishedState;
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

- (void)setState:(RPKOperationState)state {
    [self.lock lock];
    
    BOOL isPaused = [self isPaused];
    BOOL isCancelled = [self isCancelled];
    
	dispatch_sync(dispatch_get_main_queue(), ^{
        switch (state) {
            case RPKOperationExecutingState:
                [self evaluateExecutingState:isPaused];
                break;
				
            case RPKOperationPausedState:
				if ([self respondsToSelector:@selector(changeStateToPause)]) {
					[self changeStateToPause];
				}
                break;
                
            case RPKOperationCancelState:
				if ([self respondsToSelector:@selector(changeStateToCancel)]) {
					[self changeStateToCancel];
				}
                break;
				
            case RPKOperationFinishedState:
                [self evaluateFinishState:isCancelled];
                break;
                
            default:
                break;
        }
    });
	
    NSString *oldStateKey = SDKeyPathFromOperationState(self.state);
    NSString *newStateKey = SDKeyPathFromOperationState(state);
    
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
	return ([self state] == RPKOperationReadyState);
}

- (BOOL)isExecuting
{
	return ([self state] == RPKOperationExecutingState);
}

- (BOOL)isFinished
{
	return ([self state] == RPKOperationFinishedState);
}

- (BOOL)isCancelled
{
    return ([self state] == RPKOperationCancelState);
}

- (BOOL)isPaused
{
    return ([self state] == RPKOperationPausedState);
}

#pragma mark - Accessor For Subclass

- (BOOL)isConcurrent
{
	return NO;
}

- (NSString *)operationLockName {
    return kSDOperationLockName;
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

@end
