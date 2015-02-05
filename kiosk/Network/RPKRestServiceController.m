//
//  RPKServiceController.m
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKRestServiceController.h"
#import "NSError+RPK.h"

#define kSCMethodPOST						@"POST"
#define kSCMethodGET						@"GET"

@implementation RPKRestServiceController

#pragma mark - Shared Manager

+ (RPKRequestManager *)serviceManager
{
	return [RPKRequestManager sharedManager];
}

#pragma mark - Convenient

- (void)postWithParameters:(NSDictionary *)parameters headers:(NSDictionary *)headers completion:(RPKRestServiceCompletion)completion
{
	if ([self.serviceURLString length] > 0) {
		[[[self class] serviceManager] POST:self.serviceURLString
									headers:headers
								 parameters:parameters
									success:^(AFHTTPRequestOperation *requestOperation, id responseObject) {
										completion(YES, nil, responseObject);
									}
									failure:^(AFHTTPRequestOperation *requestOperation, NSError *error){
										NSError *detailError = [NSError mx_errorFromNetworkOperation:requestOperation detailError:error];
										completion(NO, detailError, nil);
									}];
	}
}

- (void)postWithParameters:(NSDictionary *)parameters completion:(RPKRestServiceCompletion)completion
{
	[self postWithParameters:parameters headers:nil completion:completion];
}

- (void)postWithCompletion:(RPKRestServiceCompletion)completion
{
	[self postWithParameters:nil completion:completion];
}

- (void)sendRequest:(NSURLRequest *)request completion:(RPKRestServiceCompletion)completion
{
	NSOperation *operation = [[[self class] serviceManager] HTTPRequestOperationWithRequest:request
																					success:^(AFHTTPRequestOperation *requestOperation, id responseObject) {
																						completion(YES, nil, responseObject);
																					}
																					failure:^(AFHTTPRequestOperation *requestOperation, NSError *error){
																						NSError *detailError = [NSError mx_errorFromNetworkOperation:requestOperation detailError:error];
																						completion(NO, detailError, nil);
																					}];
	
	[[[self class] serviceManager].operationQueue addOperation:operation];
}

@end
