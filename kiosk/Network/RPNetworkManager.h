//
//  RPNetworkManager.h
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RPService.h"

#import "RPLoginService.h"
#import "RPPreferenceService.h"

typedef void(^RPNetworkManagerCompletion)();

@interface RPNetworkManager : NSObject

#pragma mark - Setup

+ (instancetype)sharedManager;

#pragma mark - Convenient Service

+ (RPLoginService *)loginService;

+ (RPPreferenceService *)referenceService;

@end
