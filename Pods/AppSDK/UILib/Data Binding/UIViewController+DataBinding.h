//
//  UIViewController+DataBinding.h
//  UISDK
//
//  Created by PC Nguyen on 5/9/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ULViewDataSource.h"

@interface UIViewController (DataBinding) <ULViewDataSourceBindingDelegate>

/**
 *  Check wheter view controller implement the ULViewDataBinding Protocol
 *	This does not create currentBinderSource object
 *
 *  @return YES if protocol implemented and currentBinderSource not nil
 */
- (BOOL)ul_bindingExist;

/**
 *  Lazily create and return the binder data source
 *
 *  @return ULViewDataSource subclass
 */
- (ULViewDataSource *)ul_currentBinderSource;

/**
 *  determine if we should relayout
 *	if set to YES, this will trigger viewWillLayoutSubViews
 *	upon data updates
 *
 *  @param shouldLayout layout or not layout
 */
- (void)ul_setLayoutOnDataChange:(BOOL)shouldLayout;

/**
 *  Load initial data from data source
 */
- (void)ul_loadData;

#pragma mark - ULManagedDataSource Convenients

/**
 *  If the binder source is a ULManagedDataSource subclass,
 *	this will register the service for that binder source,
 *	
 *	@discuss this is typically done on viewDidLoad or init
 *  @param service the service tight to the data source
 */
- (void)ul_registerManagedService:(NSString *)service;

/**
 *  If the binder source is a ULManagedDataSource subclass,
 *	this will register the services for that binder source
 *	this is typically done on viewDidLoad or init
 *
 *	@discuss this is typically done on viewDidLoad or init
 *  @param services the service list tight to the data source
 */
- (void)ul_registerManagedServices:(NSArray *)services;

/**
 *  If the binder source is ULManagedDataSource subclass,
 *	this will remove all the services tight to that binder source,
 *
 *	@discuss this should be done upon dealloc
 */
- (void)ul_unRegisterAllManagedServices;

@end
