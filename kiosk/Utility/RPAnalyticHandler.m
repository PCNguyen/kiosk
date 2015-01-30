//
//  RPAnalyticHandler.m
//  Reputation
//
//  Created by PC Nguyen on 3/27/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAnalyticHandler.h"
#import "Mixpanel.h"
#import "RPAccountManager.h"
#import "RPReferenceHandler.h"

#import "User+RP.h"
#import "UIApplication+RP.h"
#import "NSBundle+Extension.h"
#import "MobileCommon.h"
#import "NSError+RP.h"

@implementation RPAnalyticHandler

#pragma mark - General

+ (void)configure
{
	/***
	 * Production: b93e13610e2e0885b4fb64d24d880332
	 * Development: 0720121269a8a45d2486f9c8dc4382bf
	 */
    [Mixpanel sharedInstanceWithToken:[UIApplication rp_mixPannelAPIToken]];
	
	[self registerSuperProperties];
}

+ (void)registerSuperProperties
{
	User *authenticatedUser = [[RPAccountManager sharedManager] userAccount];
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
	
	if (authenticatedUser) {
		[mixpanel identify:[authenticatedUser rp_alias]];
		
		NSString *userValue = [NSString stringWithFormat:@"%@ %@ (%@,%@)", authenticatedUser.firstName, authenticatedUser.lastName, [authenticatedUser rp_alias], authenticatedUser.email];
		NSString *tenantValue = [NSString stringWithFormat:@"%@ (%@)", authenticatedUser.tenantName, [authenticatedUser rp_tenantIDString]];
		
		[mixpanel registerSuperProperties:@{[MobileCommonConstants SUPER_PROP_USER]:userValue,
											[MobileCommonConstants SUPER_PROP_TENANT]:tenantValue,
											[MobileCommonConstants SUPER_PROP_PLATFORM]: [NSBundle ns_platformID],
											[MobileCommonConstants SUPER_PROP_VERSION]: [NSBundle ns_appVersion],
											[MobileCommonConstants SUPER_PROP_APP_NAME]: [NSBundle ns_appAnalyticName]
											}];
		
		
	} else {
		[mixpanel registerSuperProperties:@{[MobileCommonConstants SUPER_PROP_USER]: @"",
											[MobileCommonConstants SUPER_PROP_TENANT]: @"",
											[MobileCommonConstants SUPER_PROP_PLATFORM]: [NSBundle ns_platformID],
											[MobileCommonConstants SUPER_PROP_VERSION]: [NSBundle ns_appVersion],
											[MobileCommonConstants SUPER_PROP_APP_NAME]: [NSBundle ns_appAnalyticName]}];
	}
}

+ (void)trackEventName:(NSString *)eventName
{
	[[Mixpanel sharedInstance] track:eventName];
}

+ (void)trackEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
	[[Mixpanel sharedInstance] track:eventName properties:userInfo];
}

@end
