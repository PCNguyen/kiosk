//
//  DLAppStorage+RP.m
//  Reputation
//
//  Created by PC Nguyen on 12/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "DLAppStorage+RP.h"
#import "AppLibShared.h"

@implementation DLAppStorage (RP)

+ (instancetype)sharedCacheAppStorage
{
	return [[self alloc] initWithCache:[self sharedCache]];
}

+ (NSCache *)sharedCache
{
	SHARE_INSTANCE_BLOCK(^{
		return [NSCache new];
	});
}

@end
