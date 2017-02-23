//
//  RPKRequestManager.m
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKRequestManager.h"

#import "AppLibShared.h"

@implementation RPKRequestManager

+ (instancetype)sharedManager
{
	static RPKRequestManager *manager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		manager = [self manager];
		manager.requestSerializer = [AFJSONRequestSerializer new];
	});
	
	return manager;
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
						 headers:(NSDictionary *)headers
					  parameters:(id)parameters
						 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
						 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
	NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
	
	if (headers) {
		[headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
			[request setValue:value forHTTPHeaderField:key];
		}];
	}
	
	AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
	
	[self.operationQueue addOperation:operation];
	
	return operation;
}

@end
