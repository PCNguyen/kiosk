//
//  NSMutableArray+AL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AL)

/**
 *  Safely check nil on object before adding
 *
 *  @param object the object to add
 */
- (void)al_addObject:(id)object;

/**
 *  Safely check nil on object before removing
 *
 *  @param object the object to be removed
 */
- (void)al_removeObject:(id)object;

/**
 *  Safely check array before adding
 *
 *  @param array array of objects to be added
 */
- (void)al_addObjectsFromArray:(NSArray *)array;

/**
 *  Safely check index within range before removing
 *
 *  @param index index of object to be removed
 */
- (void)al_removeObjectAtIndex:(NSInteger)index;

@end
