//
//  ULViewDataSource.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULViewDataSource;

@protocol ULViewDataSourceBindingDelegate <NSObject>

@optional
/***
 * called when selectiveUpdate enable
 */
- (void)viewDataSource:(ULViewDataSource *)dataSource updateBindingKey:(NSString *)bindKey;

/***
 * called when selectiveUpdate NOT enable or batch updating complete
 */
- (void)viewDataSourceUpdateAllBindingKey:(ULViewDataSource *)dataSource;

/**
 *  a hook to signal ui that data source don't have initial data
 *	this will trigger ul_handleNoData on any UI implemented
 *
 *  @param dataSource the viewDataSource
 *	@param userInfo extra data to pass to UI
 */
- (void)viewDataSourceHasNoData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo;

/**
 *  a hook to notify ui before data source update
 *	this will trigger ul_dataWillUpdate on any UI implemented
 *
 *  @param dataSource the data source
 *	@param userInfo extra data to pass to UI
 */
- (void)viewDataSourceWillUpdateData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo;

/**
 *  a hook to execute update synchronously rather than notification based
 *	this will trigger ul_handleUpdatedProperty:userInfo: on any UI implemented
 *
 *  @param dataSource the datasource
 *  @param property   the updated property
 *  @param userInfo   the additional info about the changes
 */
- (void)viewDataSource:(ULViewDataSource *)dataSource updateProperty:(id)property userInfo:(NSDictionary *)userInfo;

/**
 *  a hook to signify data update complete in case of batch update
 *	this will trigger ul_dataDidUpdate on any UI implemented
 *
 *  @param dataSource the data source
 *	@param userInfo the extra data to pass to UI
 */
- (void)viewDataSourceDidUpdateData:(ULViewDataSource *)dataSource userInfo:(NSDictionary *)userInfo;

@end

@protocol ULViewDataBinding <NSObject>

/***
 * Returned value must be subclass of USViewDataSource.
 * Providing the dataSource for binding values.
 */
- (Class)ul_binderClass;

/***
 * A dictionary of binding values in format
 * {viewProperty : sourceProperty}
 */
- (NSDictionary *)ul_bindingInfo;

@optional

/**
 *  A hook entry for UI when data source don't have initial data
 *	Data Source call the viewDataSourceHasNoData: to trigger this
 *
 *	@param userInfo the extra data passed from dataSource
 */
- (void)ul_handleNoData:(NSDictionary *)userInfo;

/**
 *  a hook before data update source update
 *	Data Source call the viewDataSourceWillUpdateData: to trigger this
 *
 *	@param userInfo the extra data passed from dataSource
 */
- (void)ul_dataWillUpdate:(NSDictionary *)userInfo;

/**
 *  A hook to updated change from data source synchornously instead of notification based
 *	Data Source call the viewDataSource:updateProperty:userInfo: to trigger this
 *
 *  @param property the updated property
 *  @param userInfo the additional info about the changes
 */
- (void)ul_handleUpdatedProperty:(id)property userInfo:(NSDictionary *)userInfo;

/**
 *  A hook to handle batch updated data
 *	Data Source call the viewDataSourceDidUpdateData: to trigger this
 *
 *	@param userInfo the extra data passed from dataSource
 */
- (void)ul_dataDidUpdate:(NSDictionary *)userInfo;

@end

@interface ULViewDataSource : NSObject

/***
 * naming different so subClass has no issue implement their own delegate
 * this delegate should be reserved for binding process only
 */
@property (nonatomic, weak) id<ULViewDataSourceBindingDelegate>bindingDelegate;

/***
 * Default is NO.
 * If set to YES, when data update, view will also redraw.
 * data update may be wrapped between beginBatchUpdate and endBatchUpdate to avoid race condition
 * Useful if view frame is calculated dynamically based on data it contents.
 */
@property (nonatomic, assign) BOOL shouldUpdateLayout;

/***
 * If we don't want UI change until all the updates finished.
 * Wrap this before and after properties update.
 * UI update happen when endBatchUpdate get called.
 * These allow serialization via delegate methods viewDataSourceWillUpdateData: && viewDataSourceDidUpdateData:
 */
- (void)beginBatchUpdate;
- (void)endBatchUpdate;

/**
 *  The same as beginBatchUpdate and endBatchUpdate but with the option to pass extra data to UI
 *
 *  @param userInfo extra data
 */
- (void)beginBatchUpdate:(NSDictionary *)userInfo;
- (void)endBatchUpdate:(NSDictionary *)userInfo;

/**
 *  Provide an entry point to ignore non binding property
 *	Simply for clarity and enhance performance
 *	Not implement this has no affect on the view binding info
 *	Subclass should make call to super class method before implement its own
 */
- (void)configureNonBindingProperty;

/***
 * This should be called within configureNonBindingProperty
 * to exclude any non binding property
 */
- (void)ignoreUpdateProperty:(SEL)propertySelector;

/***
 * A dictionary provide mapping for additional update that tight to a key
 * Providing this will enable selective update for mapped selectors when that property change.
 * e.g
 * {
 *	 countText			: count,
 *   countFormattedText	: count,
 *   negativeCount		: count,
 *   formattedDate      : timeStamp,
 *   formattedHour		: timeStamp
 * }
 *
 * Providing empty dictionary will enable selective update for all properties without mapping
 */
- (NSDictionary *)additionalKeyUpdates;

#pragma mark - Subclass Hook

/**
 *  Subclass provide mechanism to parse data from storage into binding variables
 */
- (void)loadData;

@end
