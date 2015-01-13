//
//  RPKRequestManager.h
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface RPKRequestManager : AFHTTPRequestOperationManager

+ (instancetype)sharedManager;

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
						 headers:(NSDictionary *)headers
					  parameters:(id)parameters
						 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
						 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
