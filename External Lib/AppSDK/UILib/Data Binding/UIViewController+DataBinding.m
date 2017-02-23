//
//  UIViewController+DataBinding.m
//  UISDK
//
//  Created by PC Nguyen on 5/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIViewController+DataBinding.h"
#import "ULManagedDataSource.h"
#import "ALPropertiesTransformer.h"
#import "ALSetterTransformer.h"

#import "NSObject+AL.h"

@implementation UIViewController (DataBinding)

#pragma mark - Auto Binding

- (void)__handleBindingUpdateValue:(id)key withBindedValue:(id)bindingKey
{
	//--getter
	NSArray *getterProperties = [[ALPropertiesTransformer transformer] transformedValue:bindingKey];
	id getterOwner = [self ul_currentBinderSource];
	
	for (NSString *childProperties in getterProperties) {
		getterOwner = [self __objectFromString:childProperties owner:getterOwner];
	}
	
	NSString *getterSelectorString = [[ALSetterTransformer transformer] reverseTransformedValue:bindingKey];
	id getterValue = [self __objectFromString:getterSelectorString owner:getterOwner];
	
	//--setter
	NSArray *setterProperties = [[ALPropertiesTransformer transformer] transformedValue:key];
	id setterOwner = self;
	
	for (NSString *childProperties in setterProperties) {
		setterOwner = [self __objectFromString:childProperties owner:setterOwner];
	}
	
	NSString *setterSelectorString = [[ALSetterTransformer transformer] transformedValue:key];
	SEL setterSelector = NSSelectorFromString(setterSelectorString);
	
	//--bind value
	[setterOwner al_performSelector:setterSelector withObject:getterValue];
}

- (void)__handleAllBindingUpdates
{
	NSDictionary *binding = [self ul_bindingInfo];
	
	[binding enumerateKeysAndObjectsUsingBlock:^(id uiValue, id sourceValue, BOOL *stop) {
		[self __handleBindingUpdateValue:uiValue withBindedValue:sourceValue];
	}];
}

- (ULViewDataSource *)__binderSource
{
	ULViewDataSource *dataBinder = [self al_associateObjectForSelector:@selector(__binderSourceAssociate)];
	
	if (!dataBinder) {
		dataBinder = [self al_setAssociateObjectWithSelector:@selector(__binderSourceAssociate)];
	}
	
	return dataBinder;
}

- (ULViewDataSource *)__binderSourceAssociate
{
	ULViewDataSource *dataBinder = nil;
	Class binderClass = [self ul_binderClass];
	
	if ([binderClass isSubclassOfClass:[ULViewDataSource class]]) {
		dataBinder = [[binderClass alloc] init];
		dataBinder.bindingDelegate = self;
	}
	
	return dataBinder;
}

#pragma mark - ULViewDataBinding Protocol Mock

- (Class)ul_binderClass
{
	return [ULViewDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return [NSDictionary dictionary];
}

#pragma mark - Public Method

- (ULViewDataSource *)ul_currentBinderSource
{
	ULViewDataSource *dataBinder = nil;
	
	if ([self __isBindingMode]) {
		dataBinder = [self __binderSource];
	}
	
	return dataBinder;
}

- (BOOL)ul_bindingExist
{
	ULViewDataSource *dataBinder = [self al_associateObjectForSelector:@selector(__binderSourceAssociate)];
	
	BOOL bindingExist = ([self __isBindingMode] && (dataBinder != nil));
	
	return bindingExist;
}

- (void)ul_setLayoutOnDataChange:(BOOL)shouldLayout
{
	[self ul_currentBinderSource].shouldUpdateLayout = shouldLayout;
}

- (void)ul_loadData
{
	[[self ul_currentBinderSource] loadData];
}

#pragma mark - RPViewDataSourceDelegate

- (void)viewDataSource:(ULViewDataSource *)dataSource updateBindingKey:(NSString *)bindKey
{
	if ([self __isBindingMode]) {
		[[self ul_bindingInfo] enumerateKeysAndObjectsUsingBlock:^(id uiValue, id sourceValue, BOOL *stop){
			if ([sourceValue isEqualToString:bindKey]) {
				[self __handleBindingUpdateValue:uiValue withBindedValue:sourceValue];
			}
		}];
		
		if (dataSource.shouldUpdateLayout) {
			[self viewWillLayoutSubviews];
		}
	}
}

- (void)viewDataSourceUpdateAllBindingKey:(ULViewDataSource *)dataSource
{
	if ([self __isBindingMode]) {
		[self __handleAllBindingUpdates];
		
		if (dataSource.shouldUpdateLayout) {
			[self viewWillLayoutSubviews];
		}
	}
}

- (void)viewDataSourceHasNoData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo
{
	if ([self respondsToSelector:@selector(ul_handleNoData:)]) {
		[(id<ULViewDataBinding>)self ul_handleNoData:userInfo];
	}
}

- (void)viewDataSourceWillUpdateData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo
{
	if ([self respondsToSelector:@selector(ul_dataWillUpdate:)]) {
		[(id<ULViewDataBinding>)self ul_dataWillUpdate:userInfo];
	}
}

- (void)viewDataSource:(ULViewDataSource *)dataSource updateProperty:(id)property userInfo:(NSDictionary *)userInfo
{
	if ([self respondsToSelector:@selector(ul_handleUpdatedProperty:userInfo:)]) {
		[(id<ULViewDataBinding>)self ul_handleUpdatedProperty:property userInfo:userInfo];
	}
}

- (void)viewDataSourceDidUpdateData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo
{
	if ([self respondsToSelector:@selector(ul_dataDidUpdate:)]) {
		[(id<ULViewDataBinding>)self ul_dataDidUpdate:userInfo];
	}
}

#pragma mark - ULManagedDataSource Convenients

- (void)ul_registerManagedService:(NSString *)service
{
	if ([[self ul_currentBinderSource] isKindOfClass:[ULManagedDataSource class]]) {
		[(ULManagedDataSource *)[self ul_currentBinderSource] setManagedService:service];
	}
}

- (void)ul_registerManagedServices:(NSArray *)services
{
	if ([[self ul_currentBinderSource] isKindOfClass:[ULManagedDataSource class]]) {
		[(ULManagedDataSource *)[self ul_currentBinderSource] setManagedServices:services];
	}
}

- (void)ul_unRegisterAllManagedServices
{
	if ([self ul_bindingExist]) {
		if ([[self ul_currentBinderSource] isKindOfClass:[ULManagedDataSource class]]) {
			[(ULManagedDataSource *)[self ul_currentBinderSource] removeCurrentManagedService];
		}
	}
}

#pragma mark - Private

- (BOOL)__isBindingMode
{
	BOOL isBinding =  [[self class] conformsToProtocol:@protocol(ULViewDataBinding)];
	return isBinding;
}

- (id)__objectFromString:(NSString *)selectorString owner:(id)owner;
{
	id returnedObject = [owner al_objectFromSelector:NSSelectorFromString(selectorString)];
	
	return returnedObject;
}

@end
