//
//  RPNetworkOperation.m
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKServiceOperation.h"
#import "Mobile.h"
#import "RPAuthenticationHandler.h"

#import "NSError+RP.h"

@interface RPKServiceOperation()

@property (nonatomic, copy) RPServiceOperationBlock operationBlock;
@property (nonatomic, copy) RPServiceOperationResponseBlock responseBlock;

@property (nonatomic, weak) id networkResponse;
@property (nonatomic, strong) NSError *networkError;

@end

@implementation RPKServiceOperation

- (void)dealloc
{
	[self unRegisterNotifcation];
}

- (id)initWithNetworkBlock:(RPServiceOperationBlock)networkBlock responseCompletion:(RPServiceOperationResponseBlock)completion
{
	if (self = [super init]) {
		_retryAttempt = 0;
		_operationBlock = networkBlock;
		_responseBlock = completion;
	}
	
	return self;
}

- (BOOL)isConcurrent
{
	return YES;
}

- (void)operationDidExecute
{
	[self triggerNetworkService];
}

- (void)changeStateToFinish
{
	if (self.responseBlock) {
		if ([self.networkResponse respondsToSelector:@selector(response)]) {
			Response *response = (Response *)[self.networkResponse response];
			if (response.responseCode != ResponseCode_Success) {
				self.networkError = [NSError rp_networkErrorFromResponse:response];
			}
		} else if ([self.networkResponse isKindOfClass:[Response class]]) {
			Response *response = (Response *)self.networkResponse;
			if (response.responseCode != ResponseCode_Success) {
				self.networkError = [NSError rp_networkErrorFromResponse:response];
			}
		}
			
		self.responseBlock(self, self.networkResponse, self.networkError);
		self.responseBlock = nil;
	}
}

- (void)changeStateToCancel
{
	if (self.responseBlock) {
		self.responseBlock(self, nil, self.networkError);
		self.responseBlock = nil;
	}
}

#pragma mark - Private

- (void)triggerNetworkService
{
	@try {
		NSString *operationID;
		self.networkResponse = self.operationBlock(&operationID);
		
		if (operationID != NULL) {
			self.operationID = operationID;
		}
		
		[self finish];
	
	} @catch (NSException *exception) {
		
		BOOL isRecoverable = [NSError rp_isRecoverableNetworkException:exception];
		BOOL isKeyExpired = [NSError rp_isKeyExpiredException:exception];
		BOOL notMaxAttempt = (self.retryAttempt < kRPNetworkOperationMaxRetryAttempt);
		
		if (isRecoverable && notMaxAttempt) {
			self.retryAttempt++;
			[self triggerNetworkService];
		} else if (isKeyExpired && notMaxAttempt) {
			self.retryAttempt++;
			[self waitAndRetryWhenKeyUpdated];
		} else {
			self.networkError = [NSError rp_networkErrorFromException:exception];
			[self cancel];
		}
	}
}


- (void)waitAndRetryWhenKeyUpdated
{
	[self registerNotifcation];
	
	[RPAuthenticationHandler refreshKey];
}

#pragma mark - Notification

- (void)registerNotifcation
{
	[RPAuthenticationHandler addObserverForNetworkActivityComplete:self
														  selector:@selector(handleKeyRefreshCompleteNotification:)];
}

- (void)unRegisterNotifcation
{
	[RPAuthenticationHandler removeObserverForNetworkActivityComplete:self];
}

- (void)handleKeyRefreshCompleteNotification:(NSNotification *)notification
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
		[self triggerNetworkService];
	});	
}

@end
