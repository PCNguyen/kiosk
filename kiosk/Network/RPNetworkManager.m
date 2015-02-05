//
//  RPNetworkManager.m
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPNetworkManager.h"

#import "UIApplication+RP.h"

@interface RPNetworkManager ()

@property (nonatomic, strong) RPLoginService *loginService;
@property (nonatomic, strong) RPPreferenceService *preferenceService;

@end

@implementation RPNetworkManager

+ (instancetype)sharedManager {
	
	static RPNetworkManager *serviceManager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		serviceManager = [[RPNetworkManager alloc] init];
		
	});
	
	return serviceManager;
}

#pragma mark - Convenient Service

- (RPLoginService *)loginService
{
	if (!_loginService) {
		NSURL *loginEndpointURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@login",[UIApplication rp_fullServerURLString]]];
		_loginService = [[RPLoginService alloc] initWithServiceURL:loginEndpointURL];
	}
	
	return _loginService;
}

+ (RPLoginService *)loginService
{
	return [[RPNetworkManager sharedManager] loginService];
}

- (RPPreferenceService *)preferenceService
{
	if (!_preferenceService) {
		NSURL *serviceURL = [NSURL URLWithString:[UIApplication rp_fullServerURLString]];
		_preferenceService = [[RPPreferenceService alloc] initWithServiceURL:serviceURL];
	}
	
	return _preferenceService;
}

+ (RPPreferenceService *)referenceService
{
	return [[RPNetworkManager sharedManager] preferenceService];
}

@end
