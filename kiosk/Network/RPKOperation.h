//
//  SDOperation.h
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RPKOperationProtocol <NSObject>

#pragma mark - Operation Life Cycle For Subclass

@optional

- (void)operationDidExecute;

/* Actions to take on operation thread when pausing */
- (void)operationWillPause;

/* Actions to take on operation thread when resuming */
- (void)operationDidResume;

/* Actions to take on operation thread when cancelling */
- (void)operationWillCancel;

/* Actions to take on operation thread when finish */
- (void)operationWillFinish;

#pragma mark - Main Thread Notification

/*
 * Actions need to perform on main thread synchronously when operation start
 * Avoid using operation instance property in these actions since they might
 * not have the correct value yet
 */
- (void)changeStateToExecuting;

/*
 * Actions need to perform on main thread synchronously when operation finish
 * Avoid using operation instance property in these actions since they might
 * already been dealloc since the operation is finishing
 */
- (void)changeStateToFinish;

/*
 * Actions need to perform on main thread synchronously when operation cancel
 * Avoid using operation instance property in these actions since they might
 * already been dealloc since the operation is finishing
 */
- (void)changeStateToCancel;

/*
 * Actions need to perform on main thread synchronously when operation pause
 */
- (void)changeStateToPause;

/*
 * Actions need to perform on main thread synchronously when operation resume
 * from pausing
 */
- (void)resumeStateToExecuting;

@end

@interface RPKOperation : NSOperation <RPKOperationProtocol>

#pragma mark - Operation Control - Do not override these in subclass

- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;
- (void)finish;
- (void)terminate;

@end
