//
//  RPNetworkHandler.h
//  Reputation
//
//  Created by PC Nguyen on 5/16/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RPService.h"

typedef void(^NetworkHandlerCompletion)(NSError *error);

@interface RPNetworkHandler : NSObject

+ (NSString *)activityBeginNotificationName;
+ (NSString *)activityCompleteNotificationName;

+ (void)addObserverForNetworkActivityBegin:(id)observer selector:(SEL)selector;
+ (void)removeObserverForNetworkActivityBegin:(id)observer;

+ (void)addObserverForNetworkActivityComplete:(id)observer selector:(SEL)selector;
+ (void)removeObserverForNetworkActivityComplete:(id)observer;

+ (void)postNetworkActivityBeginNotificationForService:(RPServiceType)serviceType;
+ (void)postNetworkActivityCompleteNotificationForService:(RPServiceType)serviceType error:(NSError *)error;

#pragma mark - Threading

+ (void)serializeBlock:(void (^)())block;
+ (void)notifyDataSourceForService:(RPServiceType)serviceType error:(NSError *)error;
+ (void)safelyComplete:(NetworkHandlerCompletion)completion withError:(NSError *)error;

@end
