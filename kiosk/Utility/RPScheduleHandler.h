//
//  RPScheduleHandler.h
//  Reputation
//
//  Created by PC Nguyen on 11/20/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPScheduleHandler : NSObject

+ (void)scheduleAllServices;

+ (void)unScheduleAllServices;

+ (void)triggerAllServices;

@end
