//
//  RPAnalyticHandler.h
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kRPAnalyticHandlerEventLogin = @"Login";

@interface RPAnalyticHandler : NSObject

#pragma mark - General

+ (void)configure;
+ (void)registerSuperProperties;
+ (void)trackEventName:(NSString *)eventName;
+ (void)trackEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

@end
