//
//  ULViewDataSource.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULViewDataSource.h"

#import <objc/runtime.h>

static void *kULViewDataSourceUpdatingContext = &kULViewDataSourceUpdatingContext;

@interface ULViewDataSource ()

@property (nonatomic, strong) NSMutableArray *ignoreUpdateProperties;
@property (nonatomic, assign) BOOL isBatchUpdate;

@end

@implementation ULViewDataSource

- (id)init
{
	if (self = [super init]) {
		_shouldUpdateLayout = NO;
		
		[self configureNonBindingProperty];
		[self registerAllPropertiesForKVO];
	}
	
	return self;
}

- (void)configureNonBindingProperty
{
	[self ignoreUpdateProperty:@selector(delegate)];
	[self ignoreUpdateProperty:@selector(ignoreUpdateProperties)];
	[self ignoreUpdateProperty:@selector(isBatchUpdate)];
	[self ignoreUpdateProperty:@selector(shouldUpdateLayout)];

}

- (void)dealloc
{
	[self deRegisterAllPropertiesForKVO];
}

#pragma mark - KVO

- (void)deRegisterAllPropertiesForKVO
{
	unsigned int count;
	
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    for (int i = 0; i < count; ++i) {
        const char *propertyName = property_getName(properties[i]);
        NSString *observedName = [NSString stringWithUTF8String:propertyName];
		
		if ([self isBindingProperty:observedName]) {
			@try {
				[self removeObserver:self
						  forKeyPath:observedName
							 context:kULViewDataSourceUpdatingContext];
			} @catch (NSException *exception) {
				//--do nothing since observer is not added
			}
		}
    }
	
    free(properties);
}

- (void)registerAllPropertiesForKVO
{
	unsigned int count;
	
    objc_property_t *properties = class_copyPropertyList([self class], &count);
	
    for (int i = 0; i < count; ++i) {
        const char *propertyName = property_getName(properties[i]);
        NSString *observedName = [NSString stringWithUTF8String:propertyName];
		
		if ([self isBindingProperty:observedName]) {
			[self addObserver:self
				   forKeyPath:observedName
					  options:NSKeyValueObservingOptionNew
					  context:kULViewDataSourceUpdatingContext];
		}
    }
	
    free(properties);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	BOOL shouldUpdate = (context == kULViewDataSourceUpdatingContext);
	shouldUpdate = shouldUpdate && ![self.ignoreUpdateProperties containsObject:keyPath];
	shouldUpdate = shouldUpdate && !self.isBatchUpdate;
	
	if (shouldUpdate) {
		[self updateBindingKey:keyPath];
		
		[[self additionalKeyUpdates] enumerateKeysAndObjectsUsingBlock:^(NSString *bindingKey, NSString *propertyKey, BOOL *stop) {
			if ([propertyKey isEqualToString:keyPath]) {
				[self updateBindingKey:bindingKey];
			}
		}];
	}
}

#pragma mark - Batch Update

- (void)beginBatchUpdate
{
	[self beginBatchUpdate:nil];
}

- (void)endBatchUpdate
{
	[self endBatchUpdate:nil];
}

- (void)beginBatchUpdate:(NSDictionary *)userInfo
{
	self.isBatchUpdate = YES;
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceWillUpdateData:userInfo:)]) {
		[self.bindingDelegate viewDataSourceWillUpdateData:self userInfo:userInfo];
	}
}

- (void)endBatchUpdate:(NSDictionary *)userInfo
{
	if (self.isBatchUpdate) {
		self.isBatchUpdate = NO;
		[self updateAllBindingKey];
		if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceDidUpdateData:userInfo:)]) {
			[self.bindingDelegate viewDataSourceDidUpdateData:self userInfo:userInfo];
		}
	}
}

#pragma mark - Locking Update

- (NSMutableArray *)ignoreUpdateProperties
{
	if (!_ignoreUpdateProperties) {
		_ignoreUpdateProperties = [[NSMutableArray alloc] init];
	}
	
	return _ignoreUpdateProperties;
}

- (void)ignoreUpdateProperty:(SEL)propertySelector
{
	NSString *ignoreKeyPath = NSStringFromSelector(propertySelector);
	[self.ignoreUpdateProperties addObject:ignoreKeyPath];
}

- (BOOL)isBindingProperty:(NSString *)propertyName
{
	return ![self.ignoreUpdateProperties containsObject:propertyName];
}

#pragma mark - Additional Mapping

- (NSDictionary *)additionalKeyUpdates
{
	return nil;
}

- (void)updateAllBindingKey
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceUpdateAllBindingKey:)]) {
		[self.bindingDelegate viewDataSourceUpdateAllBindingKey:self];
	}
}

- (void)updateBindingKey:(NSString *)bindingKey
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSource:updateBindingKey:)]) {
		[self.bindingDelegate viewDataSource:self updateBindingKey:bindingKey];
	}
}

#pragma mark - Subclass Hook

- (void)loadData
{
	if ([self.bindingDelegate respondsToSelector:@selector(viewDataSourceHasNoData:userInfo:)]) {
		[self.bindingDelegate viewDataSourceHasNoData:self userInfo:nil];
	}
	
	/* Subclass inherit to provide implementation for this */
}

@end