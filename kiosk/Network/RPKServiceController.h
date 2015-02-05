//
//  RPNetworkController.h
//  Reputation
//
//  Created by PC Nguyen on 4/8/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RPKHMACHTTPClient.h"
#import "TBinaryProtocol.h"
#import "RPKServiceOperation.h"

@interface RPKServiceController : NSObject

@property (nonatomic, strong) NSURL *serviceURL;
@property (nonatomic, strong) NSOperationQueue *networkQueue;

- (id)initWithServiceURL:(NSURL *)serviceURL;

- (void)performNetworkBlock:(RPServiceOperationBlock)networkBlock
			   functionName:(NSString *)functionName
             withCompletion:(RPServiceOperationResponseBlock)completion;

- (void)performNetworkBlock:(RPServiceOperationBlock)networkBlock
			   functionName:(NSString *)functionName
			   attemptCount:(NSInteger)attemptCount
				 completion:(RPServiceOperationResponseBlock)completion;
@end
