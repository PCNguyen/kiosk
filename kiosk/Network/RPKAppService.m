//
//  RPAppService.m
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKAppService.h"
#import "RPAccountManager.h"

@implementation RPKAppService

- (User *)userAccount
{
	return [[RPAccountManager sharedManager] userAccount];
}

- (MobileClient *)serviceClient:(NSString **)correlationID
{
	*correlationID = [[NSUUID UUID] UUIDString];
	
	RPKHMACHTTPClient *hmacHTTPClient = [[RPKHMACHTTPClient alloc] initWithURL:self.serviceURL user:[self userAccount]];
	hmacHTTPClient.timeOut = 60;
	hmacHTTPClient.correlationID = *correlationID;
	
	TBinaryProtocol *binaryProtocol = [[TBinaryProtocol alloc] initWithTransport:hmacHTTPClient strictRead:YES strictWrite:YES];
	MobileClient *mobileClient = [[MobileClient alloc] initWithProtocol:binaryProtocol];
	
	return mobileClient;
}

@end
