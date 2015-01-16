//
//  RPService.m
//  Reputation
//
//  Created by PC Nguyen on 4/24/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPService.h"

#define kRPServiceTypeKey					@"ServiceTypeKey"
#define kRPServiceErrorKey					@"ServiceErrorKey"

@implementation RPService

+ (NSMutableDictionary *)userInfoForServiceType:(RPServiceType)serviceType
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:@(serviceType) forKey:kRPServiceTypeKey];
	
	return userInfo;
}

+ (NSMutableDictionary *)userInfoForServiceType:(RPServiceType)serviceType error:(NSError *)error
{
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	[userInfo setValue:@(serviceType) forKey:kRPServiceTypeKey];
	[userInfo setValue:error forKey:kRPServiceErrorKey];
	
	return userInfo;
}

+ (RPServiceType)serviceTypeFromUserInfo:(NSDictionary *)userInfo
{
	RPServiceType serviceName = ServiceNone;
	
	if ([userInfo valueForKey:kRPServiceTypeKey]) {
		serviceName = (RPServiceType)[[userInfo valueForKey:kRPServiceTypeKey] intValue];
	}
	
	return serviceName;
}

+ (NSError *)serviceErrorFromUserInfo:(NSDictionary *)userInfo
{
	NSError *error = [userInfo valueForKey:kRPServiceErrorKey];
	
	return error;
}

+ (NSString *)serviceNameFromType:(RPServiceType)serviceType
{
	return [NSString stringWithFormat:@"%d", serviceType];
}

+ (RPServiceType)serviceTypeFromName:(NSString *)serviceName
{
	RPServiceType serviceType = (RPServiceType)[serviceName integerValue];
	
	return serviceType;
}

@end
