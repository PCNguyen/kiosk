//
//  RPKServiceController.h
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPKRequestManager.h"

typedef void(^RPKRestServiceCompletion)(BOOL success, NSError *error, id response);

@interface RPKRestServiceController : NSObject

@property (nonatomic, copy) NSString *serviceURLString;

#pragma mark - Shared Manager

+ (RPKRequestManager *)serviceManager;

#pragma mark - Convenient

- (void)postWithParameters:(NSDictionary *)parameters
				   headers:(NSDictionary *)headers
				completion:(RPKRestServiceCompletion)completion;
- (void)postWithParameters:(NSDictionary *)parameters
				completion:(RPKRestServiceCompletion)completion;
- (void)postWithCompletion:(RPKRestServiceCompletion)completion;

- (void)sendRequest:(NSURLRequest *)request completion:(RPKRestServiceCompletion)completion;

@end
