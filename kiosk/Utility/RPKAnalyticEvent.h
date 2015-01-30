//
//  RPAnalyticHandler.h
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mobile.h"

#define kAnalyticSourceGoogle				@"GOOGLE+ LOCAL"
#define kAnalyticSourceKiosk				@"KIOSK"
#define kAnalyticWebPageSignUp				@"SIGN UP"
#define kAnalyticWebPageTwoFactor			@"TWO FACTOR"
#define kAnalyticSignInSuccess				@"SUCCESS"
#define kAnalyticSignInFailed				@"FAILED"
#define kAnalyticValueYES					@"YES"
#define kAnalyticValueNO					@"NO"

typedef NS_ENUM(NSInteger, RPAnalyticEventName) {
	AnalyticEventAppLaunch,
	AnalyticEventLogin,
	AnalyticEventLocationSelect,
	AnalyticEventSourceSelect,
	AnalyticEventSourceLoaded,
	AnalyticEventSourceSignin,
	AnalyticEventSourceSubmit,
	AnalyticEventSourceCancel,
	AnalyticEventSourceLogout,
	AnalyticEventSourceTimeOut,
	AnalyticEventSourceIdle,
	AnalyticEventSourceContinue,
	AnalyticEventWebPageLoad,
	AnalyticEventWebPageReload,
	AnalyticEventGoogleWidgetFailed,
};

typedef NS_ENUM(NSInteger, RPAnalyticEventProperty) {
	PropertyErrorCode,
	PropertyErrorDescription,
	PropertyAppLaunchIsAuthenticated,
	PropertyLoginSuccess,
	PropertySourceName,
	PropertySourceTimeLoad,
	PropertySourceSigninSucess,
	PropertySourcePageWillLoad,
	PropertySourcePageDidLoad,
	PropertyWebPageName,
	PropertyWebPageHost,
};

@interface RPKAnalyticEvent : NSObject

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
- (void)addProperty:(RPAnalyticEventProperty)property value:(NSString *)value;

/**
 *  Preconfigured template to report error
 *
 *  @param error the error object
 */
- (void)addPropertyForError:(NSError *)error;

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
