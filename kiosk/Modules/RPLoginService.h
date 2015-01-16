//
//  RPAuthenticationController.h
//  Reputation
//
//  Created by PC Nguyen on 4/8/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPKServiceController.h"
#import "MobileAuth.h"

typedef void(^RPLoginServiceCompletion)(BOOL success, NSError *error, LoginResponse *loginResponse);

@interface RPLoginService : RPKServiceController

- (void)authenticateWithUsername:(NSString *)username
						password:(NSString *)password
					  completion:(RPLoginServiceCompletion)completion;

- (void)refreshKeyForUser:(User *)userAccount
			   completion:(RPLoginServiceCompletion)completion;

@end
