//
//  NSObject+AL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AL)

#pragma mark - Swizzling

/**
 *  swizlling one method by another
 *
 *  @param originalSelector the orginal method
 *  @param swizzledSelector the swizzled method
 *  @param onceToken        a unique dispatch token per class
 */
+ (void)al_swizzleSelector:(SEL)originalSelector
				bySelector:(SEL)swizzledSelector
			 dispatchToken:(dispatch_once_t)onceToken;

#pragma mark - Associate Object

/**
 *  Set associate object using a selector that return a new instance of the object
 *
 *  @param objectSelector the selector that create the object instance
 *
 *  @return the associate object created by the selector
 */
- (id)al_setAssociateObjectWithSelector:(SEL)objectSelector;

/**
 *  access any previous associated object set by the selector
 *	this method does not invoke the selector
 *
 *  @param selector the selector that create the object instance
 *
 *  @return the associate object was previously set, or nil if none has been set
 */
- (id)al_associateObjectForSelector:(SEL)selector;

#pragma mark - Perform Selector

/**
 *  perform the selector to get the return object, ARC compatible
 *
 *  @param selector the selector that has a value return
 *
 *  @return the object returned by the selector
 */
- (id)al_objectFromSelector:(SEL)selector;

/**
 *  perform the selector with the object as parameter, ARC compatible
 *
 *  @param selector the selector to be performed
 *  @param object   the parameter for the selector
 */
- (void)al_performSelector:(SEL)selector withObject:(id)object;

@end
