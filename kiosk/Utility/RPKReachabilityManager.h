//
//  RPKReachabilityManager.h
//  Kiosk
//
//  Created by PC Nguyen on 2/12/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const RPKReachabilityChangedNotification;

@interface RPKReachabilityManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)isReachable;

- (void)reset;

@end
