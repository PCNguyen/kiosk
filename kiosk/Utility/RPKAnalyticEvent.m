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

#import <AppSDK/AppLibExtension.h>

#define kAnalyticSuperDeviceName			@"Device Name"
#define kAnalyticSuperLocationName			@"Location Name"
#define kAnalyticSuperSourcesEnabled		@"Source Enabled"

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
	return @"";
}

+ (NSString *)eventProperty:(RPAnalyticEventProperty)eventProperty
{
	return @"";
}

@end
