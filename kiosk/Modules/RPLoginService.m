//
//  RPAuthenticationController.m
//  Reputation
//
//  Created by PC Nguyen on 4/8/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPLoginService.h"

@implementation RPLoginService

#pragma mark - Authentication

- (void)authenticateWithUsername:(NSString *)username
						password:(NSString *)password
					  completion:(RPLoginServiceCompletion)completion
{
	__weak RPLoginService *selfPointer = self;
	
	[self performNetworkBlock:^id(NSString **correlationID) {
		
		MobileAuthClient *authenticateClient = [selfPointer authenticateClientForUserID:username correlationID:correlationID];
		return [authenticateClient login:username password:password];

	} functionName:@"login" withCompletion:^(RPKServiceOperation *operation, id responseObject, NSError *error) {
		
		LoginResponse *networkResponse = (LoginResponse *)responseObject;
		
		if (!error) {
			completion (YES, nil, networkResponse);
		} else {
			completion(NO, error, nil);
		}
	}];
}

- (void)refreshKeyForUser:(User *)userAccount completion:(RPLoginServiceCompletion)completion
{
	__weak RPLoginService *selfPointer = self;
	
	[self performNetworkBlock:^id(NSString **correlationID) {
		
		MobileAuthClient *authenticateClient = [selfPointer authenticateClientForUserID:userAccount.email correlationID:correlationID];
		return [authenticateClient refresh:userAccount.email
									userId:userAccount.id
								  tenantId:userAccount.tenantID
								   userKey:userAccount.userKey];
		
	} functionName:@"refresh" withCompletion:^(RPKServiceOperation *operation, id responseObject, NSError *error) {
		
		LoginResponse *networkResponse = (LoginResponse *)responseObject;
		
		if (!error) {
			completion (YES, nil, networkResponse);
		} else {
			completion(NO, error, nil);
		}
	}];
}

#pragma mark - Private

- (MobileAuthClient *)authenticateClientForUserID:(NSString *)userID correlationID:(NSString **)correlationID
{
	*correlationID = [[NSUUID UUID] UUIDString];
	RPKHMACHTTPClient *hmacHTTPClient = [[RPKHMACHTTPClient alloc] initWithURL:self.serviceURL authenticationID:userID];
	hmacHTTPClient.timeOut = 60;
	hmacHTTPClient.correlationID = *correlationID;
	
	TBinaryProtocol *binaryProtocol = [[TBinaryProtocol alloc] initWithTransport:hmacHTTPClient strictRead:YES strictWrite:YES];
	MobileAuthClient *mobileClient = [[MobileAuthClient alloc] initWithProtocol:binaryProtocol];
	
	return mobileClient;
}

@end
