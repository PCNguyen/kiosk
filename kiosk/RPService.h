//
//  RPService.h
//  Reputation
//
//  Created by PC Nguyen on 4/24/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ServiceNone,
	
	ServiceLogin,
	ServiceLogout,
	ServiceRefreshKey,

	ServiceGetUserConfig,
	ServiceUpdateLocationSetting,
	ServiceUpdateNotificationSetting,
	ServiceUpdateDashboardSetting,
} RPServiceType;

@interface RPService : NSObject

#pragma mark - Notification Helpers

+ (NSMutableDictionary *)userInfoForServiceType:(RPServiceType)serviceType;
+ (NSMutableDictionary *)userInfoForServiceType:(RPServiceType)serviceType error:(NSError *)error;

+ (RPServiceType)serviceTypeFromUserInfo:(NSDictionary *)userInfo;
+ (NSError *)serviceErrorFromUserInfo:(NSDictionary *)userInfo;

+ (NSString *)serviceNameFromType:(RPServiceType)serviceType;

+ (RPServiceType)serviceTypeFromName:(NSString *)serviceName;

@end
