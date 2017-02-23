//
//  NSObject+AL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+AL.h"

@implementation NSObject (AL)

#pragma mark - Swizzling

+ (void)al_swizzleSelector:(SEL)originalSelector bySelector:(SEL)swizzledSelector dispatchToken:(dispatch_once_t)onceToken
{
    dispatch_once(&onceToken, ^{
        Class class = [self class];
		
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
		
        BOOL didAddMethod =
		class_addMethod(class,
						originalSelector,
						method_getImplementation(swizzledMethod),
						method_getTypeEncoding(swizzledMethod));
		
        if (didAddMethod) {
            class_replaceMethod(class,
								swizzledSelector,
								method_getImplementation(originalMethod),
								method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Associate Object

- (id)al_setAssociateObjectWithSelector:(SEL)objectSelector
{
	id value = [self al_objectFromSelector:objectSelector];
	
	if (value) {
		objc_setAssociatedObject(self, objectSelector, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	} else {
		NSLog(@"Exception: Setting Empty Associate Object");
	}
	
	return value;
}

- (id)al_associateObjectForSelector:(SEL)selector
{
	id object = objc_getAssociatedObject(self, selector);
	return object;
}

#pragma mark - Perform Selector

- (id)al_objectFromSelector:(SEL)selector
{
	if ([self respondsToSelector:selector]) {
		IMP implementation = [self methodForSelector:selector];
		id (*function)(id, SEL) = (void *)implementation;
		return function(self, selector);
	}
	
	NSLog(@"%@ not respond to selector %@", NSStringFromClass([self class]), NSStringFromSelector(selector));
	return nil;
}

- (void)al_performSelector:(SEL)selector withObject:(id)object
{
	if ([self respondsToSelector:selector]) {
		IMP implementation = [self methodForSelector:selector];
		void (*function)(id, SEL, id) = (void *)implementation;
		function(self, selector, object);
	} else {
		NSLog(@"%@ not respond to selector %@", NSStringFromClass([self class]), NSStringFromSelector(selector));
	}
}

@end
