//
//  RPNetworkOperation.h
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKOperation.h"

#define kRPNetworkOperationMaxRetryAttempt						1

@class RPKServiceOperation;

typedef id(^RPServiceOperationBlock)(NSString **correlationID);
typedef void(^RPServiceOperationResponseBlock)(RPKServiceOperation *operation, id responseObject, NSError *error);

@interface RPKServiceOperation : RPKOperation

@property (nonatomic, assign) NSInteger retryAttempt;
@property (nonatomic, strong) NSString *operationID;

- (id)initWithNetworkBlock:(RPServiceOperationBlock)networkBlock
		responseCompletion:(RPServiceOperationResponseBlock)completion;

@end
