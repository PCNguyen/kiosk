//
//  RPKLayoutManager.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibShared.h>

#import "RPKLayoutManager.h"

@implementation RPKLayoutManager

+ (instancetype)sharedManager
{
	SHARE_INSTANCE_BLOCK(^{
		return [[self alloc] init];
	});
}

@end
