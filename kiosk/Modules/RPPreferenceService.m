//
//  RPReferenceServiceController.m
//  Reputation
//
//  Created by PC Nguyen on 4/23/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPPreferenceService.h"

@implementation RPPreferenceService

- (void)getUserConfigWithCompletion:(RPReferenceServiceConfigCompletion)completion
{
	__weak RPPreferenceService *selfPointer = self;
	
	[self performNetworkBlock:^(NSString **correlationID){
	
		return [[selfPointer serviceClient:correlationID] getUserConfig];
	
	} functionName:@"getUserConfig" withCompletion:^(RPKServiceOperation *operation, id responseObject, NSError *error) {
		
		if (!error) {
			PermissionsResponse *configResponse = (PermissionsResponse *)responseObject;
			completion(YES, nil, configResponse.config);
		} else {
			completion(NO, error, nil);
		}
	}];

}

- (void)updateUserSettings:(NSMutableArray *)userSettings completion:(AppServiceDataCompletion)completion
{
	__weak RPPreferenceService *selfPointer = self;
	
	[self performNetworkBlock:^(NSString **correlationID){
		
		return [[selfPointer serviceClient:correlationID] saveUserSettings:userSettings];
		
	} functionName:@"saveUserSettings" withCompletion:^(RPKServiceOperation *operation, id responseObject, NSError *error) {
		
		if (!error) {
			SaveSettingsResponse *settingResponse = (SaveSettingsResponse *)responseObject;
			completion(YES, nil, settingResponse.userSettings, [settingResponse.userSettings count]);
		} else {
			completion(NO, error, nil, 0);
		}
	}];

}

#pragma mark - Authentication

- (void)logoutWithCompletion:(AppServiceActionCompletion)completion
{
	//--we want to supress 205 on logout so pass in max retry attempt
	
	__weak RPPreferenceService *selfPointer = self;
	
	[self performNetworkBlock:^id(NSString **correlationID){
		
		return [[selfPointer serviceClient:correlationID] logout];
	
	} functionName:@"logout" attemptCount:kRPNetworkOperationMaxRetryAttempt completion:^(RPKServiceOperation *operation, id responseObject, NSError *error) {
		
		if (!error) {
			completion(YES, nil);
		} else {
			completion(NO, error);
		}
	}];
}

@end
