//
//  RPAuthenticationHandler.m
//  Reputation
//
//  Created by PC Nguyen on 3/5/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAuthenticationHandler.h"

#import "RPAccountManager.h"
#import "RPNetworkManager.h"
#import "RPScheduleHandler.h"

#import "RPLoginService.h"
#import "RPNotificationCenter.h"

#import "RPReferenceHandler.h"

#import "NSError+RP.h"

#import <AppSDK/UILibDataBinding.h>

NSString *const RPAuthenticationHandlerActivityBeginNotification = @" RPAuthenticationHandlerActivityBeginNotification";
NSString *const RPAuthenticationHandlerActivityCompleteNotification = @"RPAuthenticationHandlerActivityCompleteNotification";

@implementation RPAuthenticationHandler

#pragma mark - Override

+ (NSString *)activityBeginNotificationName
{
	return RPAuthenticationHandlerActivityBeginNotification;
}

+ (NSString *)activityCompleteNotificationName
{
	return RPAuthenticationHandlerActivityCompleteNotification;
}

#pragma mark - Network Task

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
	logoutLock = YES; //--to prevent logout if we have never login
	
	[self postNetworkActivityBeginNotificationForService:ServiceLogin];
	
	RPLoginServiceCompletion completion = ^(BOOL success, NSError *error, LoginResponse *response) {
		if (success) {
			if ([response.userDetails.email length] > 0) {
				[self updateAccount:response.userDetails];
				[RPReferenceHandler saveUserConfig:response.userConfig];
				[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceGetUserConfig]];
				
				[self handleAuthenticatedAccount];
//				[RPAnalyticHandler trackSuccessLogin];
			}
		} else {
			if ([error.domain isEqualToString:NSErrorResponseDomain]) {
//				[RPAnalyticHandler trackFailureLoginForUser:username errorCode:error.code];
			}
		}
		
		[self postNetworkActivityCompleteNotificationForService:ServiceLogin error:error];
	};
	
	[[RPNetworkManager loginService] authenticateWithUsername:username
													 password:password
												   completion:completion];
}

+ (void)refreshKey
{
	if (!keyRefreshLock) {
		keyRefreshLock = YES;
		
		[self postNetworkActivityBeginNotificationForService:ServiceRefreshKey];
		
		RPLoginServiceCompletion completion = ^(BOOL success, NSError *error, LoginResponse *response) {
			if (success) {
				if (response.userConfig) {
					[self updateAccount:response.userDetails];
				}
			} else {
				if ([error.domain isEqualToString:NSErrorResponseDomain]) {
					//--track failure
				}
			}
			
			[self postNetworkActivityCompleteNotificationForService:ServiceRefreshKey error:error];
			
			keyRefreshLock = NO;
		};
		
		[[RPNetworkManager loginService] refreshKeyForUser:[[RPAccountManager sharedManager] userAccount]
												completion:completion];
	}
}

#pragma mark - Local Task

+ (void)handleAuthenticatedAccount
{
	logoutLock = NO;
	
	User *userAccount = [[RPAccountManager sharedManager] userAccount];
	
	if (userAccount) {
		
		[RPNotificationCenter postAuthenticatedNotification];
		
		//--analytic
//		[RPAnalyticHandler registerSuperProperties];
		
		//--scheduler
		[RPScheduleHandler scheduleAllServices];
		
	} else {
		NSLog(@"FATAL ERROR ::: App start without user account");
	}
}

+ (void)updateAccount:(User *)userAccount
{
	[[RPAccountManager sharedManager] saveUserAccount:userAccount];
}

@end
