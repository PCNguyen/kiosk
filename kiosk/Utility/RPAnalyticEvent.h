//
//  RPAnalyticHandler.h
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mobile.h"

typedef NS_ENUM(NSInteger, RPAnalyticEventName) {
	AnalyticEventAppLaunch,
	AnalyticEventLogin,
	AnalyticEventSourceSelect,
	AnalyticEventSourceSignin,
	AnalyticEventSourceSubmit,
	AnalyticEventSourceCancel,
	AnalyticEventSourceLogout,
	AnalyticEventSourceTimeOut,
	AnalyticEventSourceContinue,
	AnalyticEventGooglePage,
	AnalyticEventPageReload,
	AnalyticEventGoogleWidgetFailed,
};

typedef NS_ENUM(NSInteger, RPAnalyticEventProperty) {
	PropertyAppLaunchIsAuthenticated,
	PropertyLoginSuccess,
	PropertySourceName,
	PropertySourceTimeLoad,
	PropertySourceSigninSucess,
	PropertySourcePageWillLoad,
	PropertySourcePageDidLoad,
	PropertyGooglePageName,
	PropertyGooglePageHost,
};

@interface RPAnalyticEvent : NSObject

#pragma mark - Initialized

/**
 *  initialize the analytic engine
 */
+ (void)configure;

#pragma mark - Super Properties Handling

/**
 *  register super property when we don't have account
 */
+ (void)registerSuperProperties;

/**
 *  register super property when we have account
 *
 *  @param user the user that is set
 */
+ (void)registerSuperPropertiesForUser:(User *)user;

/**
 *  register super property when we have both account and selected location
 *
 *  @param user     the user that is set
 *  @param location the location that is set
 */
+ (void)registerSuperPropertiesForUser:(User *)user location:(Location *)location;

#pragma mark - Event Handling

@property (nonatomic, assign) RPAnalyticEventName eventName;

/**
 *  Create an event to add property
 *
 *  @param eventName the event name enum
 *
 *  @return a preconfigured analytic event
 */
+ (instancetype)analyticEvent:(RPAnalyticEventName)eventName;

/**
 *  Adding property to an event
 *
 *  @param property the property enum
 *  @param value    the value
 */
- (void)addProperty:(RPAnalyticEventProperty)property value:(id)value;

/**
 *  Sending both event name and all the property registered
 */
- (void)send;

/**
 *  Send an event directly without configured property
 *
 *  @param eventName the event name enum
 */
+ (void)sendEvent:(RPAnalyticEventName)eventName;

/**
 *  return a string presentation of eventName
 *
 *  @param eventName the eventName enum
 *
 *  @return the event name string
 */
+ (NSString *)eventName:(RPAnalyticEventName)eventName;

/**
 *  return a string presentation of event property
 *
 *  @param eventProperty the eventProperty enum
 *
 *  @return the event property string
 */
+ (NSString *)eventProperty:(RPAnalyticEventProperty)eventProperty;

@end
