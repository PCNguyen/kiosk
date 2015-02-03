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
	[self refreshKeyForUserID:userAccount.id
						email:userAccount.email
					 tenantID:userAccount.tenantID
					  userKey:userAccount.userKey
				   completion:completion];
}

- (void)refreshKeyForUserID:(int)userID
					  email:(NSString *)email
				   tenantID:(long long)tenantID
					userKey:(NSString *)userKey
				 completion:(RPLoginServiceCompletion)completion
{
	__weak RPLoginService *selfPointer = self;
	
	[self performNetworkBlock:^id(NSString **correlationID) {
		
		MobileAuthClient *authenticateClient = [selfPointer authenticateClientForUserID:email correlationID:correlationID];
		return [authenticateClient refresh:email
									userId:userID
								  tenantId:tenantID
								   userKey:userKey];
		
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
