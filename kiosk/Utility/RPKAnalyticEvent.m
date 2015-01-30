//
//  RPAnalyticHandler.m
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKAnalyticEvent.h"
#import "Mixpanel.h"

#import "User+RP.h"
#import "UIApplication+RP.h"
#import "NSBundle+Extension.h"
#import "MobileCommon.h"
#import "NSError+RP.h"

#import <AppSDK/AppLibExtension.h>

#define kAnalyticSuperDeviceName			@"device name"
#define kAnalyticSuperLocationName			@"location name"
#define kAnalyticSuperSourcesEnabled		@"source enabled"

@interface RPKAnalyticEvent ()

@property (nonatomic, strong) NSMutableDictionary *eventProperties;

@end

@implementation RPKAnalyticEvent

#pragma mark - General

+ (void)configure
{
	/***
	 * Production: b93e13610e2e0885b4fb64d24d880332
	 * Development: 0720121269a8a45d2486f9c8dc4382bf
	 */
    [Mixpanel sharedInstanceWithToken:[UIApplication rp_mixPannelAPIToken]];
}

#pragma mark - Super Properties Handling

+ (void)registerSuperProperties
{
	Mixpanel *mixpanel = [Mixpanel sharedInstance];
	
	[mixpanel registerSuperProperties:@{[MobileCommonConstants SUPER_PROP_USER]: @"",
										[MobileCommonConstants SUPER_PROP_TENANT]: @"",
										[MobileCommonConstants SUPER_PROP_PLATFORM]: [NSBundle ns_platformID],
										[MobileCommonConstants SUPER_PROP_VERSION]: [NSBundle ns_appVersion],
										[MobileCommonConstants SUPER_PROP_APP_NAME]: [NSBundle ns_appAnalyticName],
										kAnalyticSuperDeviceName: [UIDevice currentDevice].name,
										kAnalyticSuperLocationName: @"",
										kAnalyticSuperSourcesEnabled: @""}];
}

+ (void)registerSuperPropertiesForUser:(User *)user
{
	if (user) {
		Mixpanel *mixpanel = [Mixpanel sharedInstance];
		[mixpanel identify:[user rp_alias]];
		NSString *userValue = [NSString stringWithFormat:@"%@ %@ (%@,%@)", user.firstName, user.lastName, [user rp_alias], user.email];
		NSString *tenantValue = [NSString stringWithFormat:@"%@ (%@)", user.tenantName, [user rp_tenantIDString]];
		[mixpanel registerSuperProperties:@{[MobileCommonConstants SUPER_PROP_USER]: userValue,
											[MobileCommonConstants SUPER_PROP_TENANT]: tenantValue,
											[MobileCommonConstants SUPER_PROP_PLATFORM]: [NSBundle ns_platformID],
											[MobileCommonConstants SUPER_PROP_VERSION]: [NSBundle ns_appVersion],
											[MobileCommonConstants SUPER_PROP_APP_NAME]: [NSBundle ns_appAnalyticName],
											kAnalyticSuperDeviceName: [UIDevice currentDevice].name,
											kAnalyticSuperLocationName: @"",
											kAnalyticSuperSourcesEnabled: @""}];
	}
}

+ (void)registerSuperPropertiesForUser:(User *)user location:(Location *)location
{
	if (user && location) {
		Mixpanel *mixpanel = [Mixpanel sharedInstance];
		[mixpanel identify:[user rp_alias]];
		NSString *userValue = [NSString stringWithFormat:@"%@ %@ (%@,%@)", user.firstName, user.lastName, [user rp_alias], user.email];
		NSString *tenantValue = [NSString stringWithFormat:@"%@ (%@)", user.tenantName, [user rp_tenantIDString]];
		NSString *locationValue = [NSString stringWithFormat:@"%@ (%@)", location.name, location.code];
		NSMutableArray *locationSources = [NSMutableArray array];
		
		if ([location.kioskUrl length] > 0) {
			[locationSources addObject:kAnalyticSourceKiosk];
		}
		
		for (SourceUrl *sourceURL in location.sourceUrls) {
			[locationSources addObject:sourceURL.source];
		}
		
		NSDictionary *properties = @{
									 [MobileCommonConstants SUPER_PROP_USER]: userValue,
									 [MobileCommonConstants SUPER_PROP_TENANT]: tenantValue,
									 [MobileCommonConstants SUPER_PROP_PLATFORM]: [NSBundle ns_platformID],
									 [MobileCommonConstants SUPER_PROP_VERSION]: [NSBundle ns_appVersion],
									 [MobileCommonConstants SUPER_PROP_APP_NAME]: [NSBundle ns_appAnalyticName],
									 kAnalyticSuperDeviceName: [UIDevice currentDevice].name,
									 kAnalyticSuperLocationName: locationValue,
									 kAnalyticSuperSourcesEnabled: [locationSources al_stringSeparatedByString:@", "]
									 };
		[mixpanel registerSuperProperties:properties];
	}
}

#pragma mark - Accessor

- (NSMutableDictionary *)eventProperties
{
	if (!_eventProperties) {
		_eventProperties = [NSMutableDictionary dictionary];
	}
	
	return _eventProperties;
}

#pragma mark - Event Handling

+ (instancetype)analyticEvent:(RPAnalyticEventName)eventName
{
	RPKAnalyticEvent *event = [RPKAnalyticEvent new];
	event.eventName = eventName;
	return event;
}

- (void)addProperty:(RPAnalyticEventProperty)property value:(NSString *)value
{
	[self.eventProperties setValue:value forKey:[[self class] eventProperty:property]];
}

- (void)addPropertyForError:(NSError *)error
{
	NSDictionary *userInfo = error.userInfo;
	NSString *serverMessage = [userInfo valueForKey:NSErrorServerDescriptionKey];
	NSString *errorCode = [NSString stringWithFormat:@"%d", (int)error.code];
	[self addProperty:PropertyErrorDescription value:serverMessage];
	[self addProperty:PropertyErrorCode value:errorCode];
}

- (void)send
{
	NSString *eventName = [[self class] eventName:self.eventName];
	
	if ([self.eventProperties count] > 0) {
		[[Mixpanel sharedInstance] track:eventName properties:self.eventProperties];
	} else {
		[[Mixpanel sharedInstance] track:eventName];
	}
}

+ (void)sendEvent:(RPAnalyticEventName)eventName
{
	RPKAnalyticEvent *event = [[self class] analyticEvent:eventName];
	[event send];
}

+ (NSString *)eventName:(RPAnalyticEventName)eventName
{
	switch (eventName) {
		case AnalyticEventAppLaunch:
			return @"App Launch";
		case AnalyticEventGoogleWidgetFailed:
			return @"Google Widget Failed";
		case AnalyticEventLogin:
			return @"Login";
		case AnalyticEventSourceCancel:
			return @"Source Cancel";
		case AnalyticEventSourceContinue:
			return @"Source Continue";
		case AnalyticEventSourceIdle:
			return @"Source Idle";
		case AnalyticEventSourceLoaded:
			return @"Source Loaded";
		case AnalyticEventSourceLogout:
			return @"Source Logout";
		case AnalyticEventSourceSelect:
			return @"Source Select";
		case AnalyticEventSourceSignin:
			return @"Source Signin";
		case AnalyticEventSourceSubmit:
			return @"Source Submit";
		case AnalyticEventSourceTimeOut:
			return @"Source Timeout";
		case AnalyticEventWebPageLoad:
			return @"Web Page Load";
		case AnalyticEventWebPageReload:
			return @"Web Page Reload";
		case AnalyticEventLocationSelect:
			return @"Location Select";
		default:
			break;
	};
	
	return @"Unknown Event";
}

+ (NSString *)eventProperty:(RPAnalyticEventProperty)eventProperty
{
	switch (eventProperty) {
		case PropertyAppLaunchIsAuthenticated:
			return @"is authenticated";
		case PropertyErrorCode:
			return @"error code";
		case PropertyErrorDescription:
			return @"error description";
		case PropertyWebPageHost:
			return @"web host";
		case PropertyLoginSuccess:
		case PropertySourceSigninSucess:
			return @"login success";
		case PropertySourceName:
			return @"source name";
		case PropertySourcePageDidLoad:
			return @"page did load";
		case PropertySourcePageWillLoad:
			return @"page will load";
		case PropertySourceTimeLoad:
			return @"source time load";
		case PropertyWebPageName:
			return @"web page name";
		default:
			break;
	};
	
	return @"unknown property";
}

@end
