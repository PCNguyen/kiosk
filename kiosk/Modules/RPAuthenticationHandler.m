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
#import "RPKAnalyticEvent.h"

#import "NSError+RP.h"

#import <AppSDK/UILibDataBinding.h>

NSString *const RPAuthenticationHandlerActivityBeginNotification = @" RPAuthenticationHandlerActivityBeginNotification";
NSString *const RPAuthenticationHandlerActivityCompleteNotification = @"RPAuthenticationHandlerActivityCompleteNotification";
NSString *const AuthenticationHandlerAuthenticatedNotification = @"AuthenticationHandlerAuthenticatedNotification";
NSString *const AuthenticationHandlerAuthenticationRequiredNotification = @"AuthenticationHandlerAuthenticationRequiredNotification";

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
		
		RPKAnalyticEvent *loginEvent = [RPKAnalyticEvent analyticEvent:AnalyticEventLogin];
		
		if (success) {
			if ([response.userDetails.email length] > 0) {
				[self updateAccount:response.userDetails];
				[RPReferenceHandler saveUserConfig:response.userConfig];
				[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceGetUserConfig]];
				
				[self handleAuthenticatedAccount];
				[loginEvent addProperty:PropertyAppLaunchIsAuthenticated value:@"Success"];
			} else {
				[loginEvent addProperty:PropertyAppLaunchIsAuthenticated value:@"Failed"];
			}
		} else {
			[loginEvent addProperty:PropertyAppLaunchIsAuthenticated value:@"Failed"];
			[loginEvent addPropertyForError:error];
			
			if ([error.domain isEqualToString:NSErrorResponseDomain]) {
				
			}
		}
		
		[loginEvent send];
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
		
		[RPNotificationCenter postNotificationName:AuthenticationHandlerAuthenticatedNotification object:nil];
		
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
