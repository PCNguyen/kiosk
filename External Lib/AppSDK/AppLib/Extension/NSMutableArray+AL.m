//
//  NSMutableArray+AL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSMutableArray+AL.h"

@implementation NSMutableArray (AL)

- (void)al_addObject:(id)object
{
	if (object) {
		[self addObject:object];
	}
}

- (void)al_removeObject:(id)object
{
	if (object) {
		[self removeObject:object];
	}
}

- (void)al_addObjectsFromArray:(NSArray *)array
{
	if ([array count] > 0) {
		[self addObjectsFromArray:array];
	}
}

- (void)al_removeObjectAtIndex:(NSInteger)index
{
	if (index < [self count]) {
		[self removeObjectAtIndex:index];
	}
}

@end
