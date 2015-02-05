//
//  RPNotificationCenter.h
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPNotificationCenter : NSObject

#pragma mark - NSNotificationCenter Wrapper

+ (void)postNotificationName:(NSString *)name userInfo:(NSDictionary *)userInfo;

+ (void)postNotificationName:(NSString *)name object:(id)object;

+ (void)registerObject:(id)object forNotificationName:(NSString *)name handler:(SEL)handler parameter:(id)parameter;

+ (void)unRegisterObject:(id)object forNotificationName:(NSString *)name parameter:(id)parameter;

+ (void)unRegisterAllNotificationForObject:(id)object;

@end
