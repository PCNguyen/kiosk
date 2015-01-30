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

}

+ (void)registerSuperPropertiesForUser:(User *)user
{

}

+ (void)registerSuperPropertiesForUser:(User *)user location:(Location *)location
{

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
