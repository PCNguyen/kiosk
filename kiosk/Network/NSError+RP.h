//
//  NSError+RP.h
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Mobile.h"

typedef enum {
	NetworkDomainErrorUpgrade = 400,
	NetworkDomainErrorRetry = 401,
	NetworkDomainErrorLogout = 403,
	NetworkDomainErrorService = 503,
	NetworkDomainErrorKeyExpired = 205,
	NetworkDomainErrorInvalidHTTPResponse = 901,
	NetworkDomainErrorEmptyResponse = 902,
} NetworkDomainErrorCode;

extern NSString *const NSErrorNetworkDomain;
extern NSString *const NSErrorResponseDomain;
extern NSString *const NSErrorUserDescriptionKey;
extern NSString *const NSErrorServerDescriptionKey;

@interface NSError (RP)

+ (void)rp_handleError:(NSError *)error fromViewController:(UIViewController *)viewController;

#pragma mark - Predefined Network Error

+ (NSError *)rp_networkErrorWithCode:(NSInteger)code;

#pragma mark - Network Error

+ (NSError *)rp_networkErrorFromException:(NSException *)exception;
+ (BOOL)rp_isRecoverableNetworkException:(NSException *)exception;
+ (BOOL)rp_isKeyExpiredException:(NSException *)exception;
+ (void)rp_handleNetworkError:(NSError *)error fromViewController:(UIViewController *)viewController;

#pragma mark - Response Error

+ (NSError *)rp_networkErrorFromResponse:(Response *)response;
+ (void)rp_handleResponseError:(NSError *)error fromViewController:(UIViewController *)viewController;

@end
