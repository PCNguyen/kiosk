//
//  RPHMACHTTPClient.h
//  Reputation
//
//  Created by PC Nguyen on 3/24/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTransport.h"
#import "Mobile.h"

@interface RPKHMACHTTPClient : NSObject <TTransport>

@property (nonatomic, assign) NSInteger timeOut;
@property (nonatomic, strong) NSString *correlationID;

/* Authentication Endpoint **/
- (id)initWithURL:(NSURL *)serverURL authenticationID:(NSString *)authenticationID;

/* Data Endpoint **/
- (id)initWithURL:(NSURL *)serverURL
			 user:(User *)user;

- (id)initWithURL:(NSURL *)serverURL
		userAgent:(NSString *)userAgent
		  timeout:(NSInteger)timeout
			 user:(User *)user;

@end
