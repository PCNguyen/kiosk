//
//  RPKServiceController.h
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPKRequestManager.h"

typedef void(^RPKNetworkControllerCompletion)(BOOL success, NSError *error, id response);

@interface RPKServiceController : NSObject

@property (nonatomic, copy) NSString *serviceURLString;

#pragma mark - Shared Manager

+ (RPKRequestManager *)serviceManager;

#pragma mark - Convenient

- (void)postWithParameters:(NSDictionary *)parameters
				   headers:(NSDictionary *)headers
				completion:(RPKNetworkControllerCompletion)completion;
- (void)postWithParameters:(NSDictionary *)parameters
				completion:(RPKNetworkControllerCompletion)completion;
- (void)postWithCompletion:(RPKNetworkControllerCompletion)completion;

- (void)sendRequest:(NSURLRequest *)request completion:(RPKNetworkControllerCompletion)completion;

@end
