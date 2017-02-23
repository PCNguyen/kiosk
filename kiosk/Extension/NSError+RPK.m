//
//  NSError+RPK.m
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "NSError+RPK.h"

#import <AFNetworking/AFNetworking.h>

@implementation NSError (RPK)

+ (NSError *)mx_errorFromResponse:(NSString *)responseError
{
	NSError *error = nil;
	
	if ([responseError length] > 0) {
		//--TODO: handle this more acccurately
		error = [NSError errorWithDomain:responseError code:-10001 userInfo:nil];
	}
	
	return error;
}

+ (NSError *)mx_errorFromNetworkOperation:(AFHTTPRequestOperation *)operation detailError:(NSError *)error
{
	NSHTTPURLResponse *response = operation.response;
	
	NSError *returnedError = nil;
	
	if (response.statusCode != 200) {
		returnedError = [NSError errorWithDomain:error.domain code:response.statusCode userInfo:nil];
	}
	
	return returnedError;
}

@end
