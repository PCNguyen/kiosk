//
//  ULDataSourceManager.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ULManagedDataSource;

@interface ULDataSourceManager : NSObject

+ (instancetype)sharedManager;

/**
 *  track a datasource based on service
 *	multiple datasources can be register under the same service name
 *
 *  @param dataSource  the dataSource need to be tracked
 *  @param serviceName the service that tight to the dataSource
 */
- (void)registerDataSource:(ULManagedDataSource *)dataSource forService:(NSString *)serviceName;

/**
 *  untrack a datasource to allow it to be removed from memory
 *
 *  @param dataSource  the dataSource need to be released
 *  @param serviceName the service that tight to the dataSource
 */
- (void)unRegisterDataSource:(ULManagedDataSource *)dataSource fromService:(NSString *)serviceName;

/**
 *  notify the tracked dataSource that matche the service to reload its internal data
 *	this method asynchronously triggered the handleDataUpdatedForService: on ULManagedDataSource
 *
 *  @param serviceName the service that tight to the dataSource
 */
- (void)notifyDataSourcesOfService:(NSString *)serviceName;

/**
 *  same as notifyDataSourcesOfService but with the option to communicate error
 *
 *  @param serviceName the service name
 *  @param error       error, if any
 */
- (void)notifyDataSourcesOfService:(NSString *)serviceName error:(NSError *)error;

/**
 *  update all tracked dataSource that matched the class name to reload its internal data
 *	this method synchronously triggered loadData on ULManagedDataSource
 *
 *  @param dataSourceClass a subclass of ULManagedDataSource
 */
- (void)loadDataForAllClassInstances:(Class)dataSourceClass;

/**
 *  Call load data on all registered data source. Useful if all app data has been reset
 */
- (void)loadAllDataSources;

@end
