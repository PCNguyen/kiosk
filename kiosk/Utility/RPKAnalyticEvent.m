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

- (instancetype)initWithEventName:(RPAnalyticEventName)eventName
{
	if (self = [super init]) {
		_eventName = eventName;
	}
	
	return self;
}

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
	RPKAnalyticEvent *event = [[RPKAnalyticEvent alloc] initWithEventName:eventName];
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
	
	NSString *userEvent = [[self class] eventName:AnalyticEventUserActivity];
	NSString *userActivityName = [[self class] eventProperty:PropertyActivityName];
	__block NSMutableDictionary *userActivityProperties = [NSMutableDictionary dictionary];
	[userActivityProperties setValue:eventName forKey:userActivityName];
	[userActivityProperties addEntriesFromDictionary:self.eventProperties];
	
	[[Mixpanel sharedInstance] track:userEvent properties:userActivityProperties];
}

+ (void)sendEvent:(RPAnalyticEventName)eventName
{
	RPKAnalyticEvent *event = [[self class] analyticEvent:eventName];
	[event send];
}

+ (NSString *)eventName:(RPAnalyticEventName)eventName
{
	switch (eventName) {
		case AnalyticEventUserActivity:
			return @"K_User Activity";
			break;
		case AnalyticEventAppLaunch:
			return @"K_App Launch";
			break;
		case AnalyticEventGoogleWidgetFailed:
			return @"K_Google Widget Failed";
			break;
		case AnalyticEventLogin:
			return @"K_Login";
			break;
		case AnalyticEventSilentLogin:
			return @"K_Silent Login";
			break;
		case AnalyticEventSourceCancel:
			return @"K_Source Cancel";
			break;
		case AnalyticEventSourceContinue:
			return @"K_Source Continue";
			break;
		case AnalyticEventSourceIdle:
			return @"K_Source Idle";
			break;
		case AnalyticEventSourceLoaded:
			return @"K_Source Loaded";
			break;
		case AnalyticEventSourceLogout:
			return @"K_Source Logout";
			break;
		case AnalyticEventSourceSelect:
			return @"K_Source Select";
			break;
		case AnalyticEventSourceSignin:
			return @"K_Source Signin";
			break;
		case AnalyticEventSourceSubmit:
			return @"K_Source Submit";
			break;
		case AnalyticEventSourceTimeOut:
			return @"K_Source Timeout";
			break;
		case AnalyticEventWebPageLoad:
			return @"K_Web Page Load";
			break;
		case AnalyticEventWebPageReload:
			return @"K_Web Page Reload";
			break;
		case AnalyticEventLocationSelect:
			return @"K_Location Select";
			break;
		default:
			break;
	};
	
	return @"K_Unknown Event";
}

+ (NSString *)eventProperty:(RPAnalyticEventProperty)eventProperty
{
	switch (eventProperty) {
		case PropertyActivityName:
			return @"k_activity name";
			break;
		case PropertyAppLaunchIsAuthenticated:
			return @"k_is authenticated";
			break;
		case PropertyErrorCode:
			return @"k_error code";
			break;
		case PropertyErrorDescription:
			return @"k_error description";
			break;
		case PropertyWebPageHost:
			return @"k_web host";
			break;
		case PropertyLoginSuccess:
		case PropertySourceSigninSucess:
			return @"k_login success";
			break;
		case PropertySourceName:
			return @"k_source name";
			break;
		case PropertySourcePageDidLoad:
			return @"k_page did load";
			break;
		case PropertySourcePageWillLoad:
			return @"k_page will load";
			break;
		case PropertySourceTimeLoad:
			return @"k_source time load";
			break;
		case PropertyWebPageName:
			return @"k_web page name";
			break;
		default:
			break;
	};
	
	return @"k_unknown property";
}

@end
