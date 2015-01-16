//
//  RPNetworkController.m
//  Reputation
//
//  Created by PC Nguyen on 4/8/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKServiceController.h"

@implementation RPKServiceController

- (id)initWithServiceURL:(NSURL *)serviceURL
{
	if (self = [super init]) {
		_serviceURL = serviceURL;
	}
	
	return self;
}

#pragma mark - Network Queue

- (NSOperationQueue *)networkQueue
{
	if (!_networkQueue) {
		_networkQueue = [[NSOperationQueue alloc] init];
		_networkQueue.maxConcurrentOperationCount = 1;
	}
	
	return _networkQueue;
}

- (void)performNetworkBlock:(RPServiceOperationBlock)networkBlock
			   functionName:(NSString *)functionName
             withCompletion:(RPServiceOperationResponseBlock)completion
{
	[self performNetworkBlock:networkBlock
				 functionName:functionName
				 attemptCount:0
				   completion:completion];
}

- (void)performNetworkBlock:(RPServiceOperationBlock)networkBlock
			   functionName:(NSString *)functionName
			   attemptCount:(NSInteger)attemptCount
				 completion:(RPServiceOperationResponseBlock)completion
{
	NSDate *anchorTime = [NSDate date];
	
	RPServiceOperationResponseBlock responseBlock = ^(RPKServiceOperation *operation, id response, NSError *error) {
		//--track failure
//		[RPAnalyticHandler trackAPIName:functionName error:error];
		
		//--track performance
//		long interval = [anchorTime timeIntervalSinceNow] * (-1000);
//		[RPAnalyticHandler trackConnectionTime:interval
//								  functionName:functionName
//								 correlationID:(operation.operationID ? operation.operationID : @"")
//										 error:error];
		
		
		completion(operation, response, error);
	};
	
	RPKServiceOperation *networkOperation = [[RPKServiceOperation alloc] initWithNetworkBlock:networkBlock
																		 responseCompletion:responseBlock];
	networkOperation.retryAttempt = attemptCount;
	
	[self.networkQueue addOperation:networkOperation];
}

@end
