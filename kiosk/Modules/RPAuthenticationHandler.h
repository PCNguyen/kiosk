//
//  RPAuthenticationHandler.h
//  Reputation
//
//  Created by PC Nguyen on 3/5/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPNetworkHandler.h"

static BOOL logoutLock;
static BOOL keyRefreshLock;

@interface RPAuthenticationHandler : RPNetworkHandler

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password;
+ (void)refreshKey;
+ (void)handleAuthenticatedAccount;

@end
