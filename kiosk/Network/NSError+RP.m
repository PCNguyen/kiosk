//
//  NSError+RP.m
//  Reputation
//
//  Created by PC Nguyen on 4/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "NSError+RP.h"
#import "RPAuthenticationHandler.h"

#import "Mobile.h"
#import "MobileAuth.h"
#import "NSBundle+Extension.h"
#import "UIApplication+RP.h"
#import "UIViewController+Alert.h"

NSString *const NSErrorNetworkDomain					= @"NSErrorNetworkDomain";
NSString *const NSErrorResponseDomain					= @"NSErrorResponseDomain";
NSString *const NSErrorUserDescriptionKey				= @"NSErrorUserDescriptionKey";
NSString *const NSErrorServerDescriptionKey				= @"NSErrorServerDescriptionKey";

#define kNSErrorNoErrorCode								0

static NSInteger currentErrorCode;

@implementation NSError (RP)

+ (void)rp_handleError:(NSError *)error fromViewController:(UIViewController *)viewController
{
	if ([error code] != currentErrorCode) {
		currentErrorCode = [error code];
		
		if ([error.domain isEqualToString:NSErrorNetworkDomain]) {
			[self rp_handleNetworkError:error fromViewController:viewController];
		} else if ([error.domain isEqualToString:NSErrorResponseDomain]){
			[self rp_handleResponseError:error fromViewController:viewController];
		}
	}
}

#pragma mark - Predefined Network Error

+ (NSError *)rp_networkErrorWithCode:(NSInteger)code
{
	NSString *errorDescription = @"";
	
	switch (code) {
		case NetworkDomainErrorInvalidHTTPResponse:
			errorDescription = [self errorMessage:@"Invalid HTTP Response" code:code];
			break;
		case NetworkDomainErrorLogout:
			errorDescription = @"";
			break;
		case kCFURLErrorCannotFindHost:
		case kCFURLErrorCannotConnectToHost:
			errorDescription = [self errorMessage:@"Service unavailable at the moment, please try again later" code:code];
			break;
		case kCFURLErrorNotConnectedToInternet:
		case kCFURLErrorNetworkConnectionLost:
			errorDescription = [self errorMessage:@"Please check your network connectivity or try again later" code:code];
			break;
		case NetworkDomainErrorRetry:
			errorDescription = [self errorMessage:@"Service retry error" code:code];
			break;
		case NetworkDomainErrorUpgrade:
			errorDescription = @"New version of the app is available";
			break;
		case NetworkDomainErrorService:
			errorDescription = [self errorMessage:@"Service unavailable. Retry later" code:code];
			break;
		default:
			errorDescription = [self errorMessage:@"Network error. Please try again later" code:code];
			break;
	}
	
	NSError *error = [NSError errorWithDomain:NSErrorNetworkDomain
										 code:code
									 userInfo:@{NSErrorUserDescriptionKey:errorDescription}];
	
	return error;
}

#pragma mark - Network Error

+ (NSError *)rp_networkErrorFromException:(NSException *)exception
{
	NSDictionary *userInfo = [exception userInfo];
	NSError *detectedError = nil;
	
	if (userInfo) {
		detectedError = [userInfo valueForKey:@"error"];
	}
	
	return detectedError;
}

+ (void)rp_handleNetworkError:(NSError *)error fromViewController:(UIViewController *)viewController
{
	NSString *message = [error.userInfo valueForKey:NSErrorUserDescriptionKey];
	
	switch ([error code]) {
		case NetworkDomainErrorLogout:
			break;
			
		case NetworkDomainErrorUpgrade:
            [self handleUpgradeErrorWithMessage:message fromViewController:viewController];
			break;
			
		default:
			[viewController rp_showAlertViewWithTitle:@"Error" message:message cancelBlock:^(){
										   currentErrorCode = kNSErrorNoErrorCode;
										   }];
			break;
	}
}

+ (BOOL)rp_isRecoverableNetworkException:(NSException *)exception
{
	BOOL isRecoverable = [self errorCodeOfException:exception
										matchedCode:NetworkDomainErrorRetry];
	return isRecoverable;
}

+ (BOOL)rp_isKeyExpiredException:(NSException *)exception
{
	BOOL isKeyExpired = [self errorCodeOfException:exception
									   matchedCode:NetworkDomainErrorKeyExpired];
	return isKeyExpired;
}

#pragma mark - Network Error Handler

+ (void)handleUpgradeErrorWithMessage:(NSString *)message fromViewController:(UIViewController *)viewController
{
	[viewController rp_showAlertViewWithTitle:@"Message" message:message cancelTitle:@"Upgrade" cancelBlock:^{
		NSString *appStoreURL = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@/%@?ls=1&mt=8",
								 [UIApplication rp_itunesAppName],
								 [UIApplication rp_itunesAppID]];
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreURL]];
		currentErrorCode = kNSErrorNoErrorCode;
	}];
}

+ (void)handleReachabilityErrorFromViewController:(UIViewController *)viewController
{
	[viewController rp_showAlertViewWithTitle:@"Error" message:@"Please check your network connectivity or try again later." cancelBlock:^{
		currentErrorCode = kNSErrorNoErrorCode;
	}];
}

#pragma mark - Response Error

+ (NSError *)rp_networkErrorFromResponse:(Response *)response
{
	Error *serverError = response.error;
	NSError *networkError = nil;

	if (serverError) {
		int serverErrorCode = serverError.code;
		NSString *serverErrorMessage = serverError.message;
		NSString *userErrorMessage = [self rp_messageForResponseError:serverError];
		userErrorMessage = [self errorMessage:userErrorMessage code:serverErrorCode];

		NSDictionary *userInfo = @{NSErrorUserDescriptionKey: userErrorMessage,
								   NSErrorServerDescriptionKey: serverErrorMessage};

		networkError = [NSError errorWithDomain:NSErrorResponseDomain code:(int)[serverError code] userInfo:userInfo];
	}
	
	return networkError;
}

+ (void)rp_handleResponseError:(NSError *)error fromViewController:(UIViewController *)viewController
{
	NSString *message = [error.userInfo valueForKey:NSErrorUserDescriptionKey];
	
	[viewController rp_showAlertViewWithTitle:@"Error" message:message cancelBlock:^{
		currentErrorCode = kNSErrorNoErrorCode;
	}];
}

+ (NSString *)rp_messageForResponseError:(Error *)error
{
	NSInteger errorCode = [error code];
	
	if (errorCode ==  [MobileConstants ERROR_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SOURCES_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SOCIAL_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_RATING_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_GETRATING_SVC]) {
		return [self genericNetworkErrorMessage];

	} else if (errorCode == [MobileConstants ERROR_PUBLISH_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SAVE_DISTRIBUTION_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_DELETE_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SAVE_REQREV_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_REVIEW_RESPONSE_SVC]) {
		return [self genericNetworkErrorMessage];
		
	} else if (errorCode == [MobileConstants ERROR_SOCIAL_REPLY_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SOCIAL_POST_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_SOCIAL_S3_SVC]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_AUTH_READ_RATINGS]) {
		return @"You do not have authorization to mark this rating read";
	
	} else if (errorCode == [MobileConstants ERROR_AUTH_READ_SOCIAL]) {
		return @"You do not have authorization to mark this post read";
		
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_RATINGID]) {
		return [self genericNetworkErrorMessage];
		
	} else if (errorCode == [MobileConstants ERROR_AUTH_PUBLISH_RATING]) {
		return @"You do not have authorization to publish this post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_PUBLISH]) {
		return @"You do not have authorization to publish this post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_UNPUBLISH]) {
		return @"You do not have authorization to unpublish this post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_NOTKIOSK]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_AUTH_DELETE_RATING]) {
		return @"You do not have authorization to delete this rating";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_RFMESSAGE]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_EMAIL]) {
		return @"Please enter a valid email";
		
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_REPLY_ID]) {
		return [self genericNetworkErrorMessage];
		
	} else if (errorCode == [MobileConstants ERROR_AUTH_REPLY_RATING]) {
		return @"You do not have authorization to reply to this post";
	
	} else if (errorCode == [MobileConstants ERROR_AUTH_FLAG_POST]) {
		return @"You do not have authorization to flag this post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_POSTTEXT]) {
		return @"Please enter content";
		
	} else if (errorCode == [MobileConstants ERROR_AUTH_POST_SOCIAL]) {
		return @"You do not have authorization to post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_NO_LOCATION]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_NO_SOURCE]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_TIME]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_REQUEST]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_TRANSMISSION]) {
		return [self genericNetworkErrorMessage];
	
	} else if (errorCode == [MobileConstants ERROR_AUTH_SOCIAL_APPROVE_REJECT]) {
		return @"You do not have authorization to approve/reject post";
	
	} else if (errorCode == [MobileConstants ERROR_VALIDATION_SOCIAL_DUPLICATE]) {
		return @"Failed to publish post due to duplicated content. Please retry.";
		
	} else if (errorCode == [MobileAuthConstants ERROR_AUTHENTICATION_FAILED]) {
		return @"Invalid Username and Password";
		
	} else {
		return [self genericNetworkErrorMessage];
	}
}

#pragma mark - Convenient

+ (NSString *)genericNetworkErrorMessage
{
	return @"Please try again later";
}

+ (NSString *)errorMessage:(NSString *)message code:(NSInteger)code
{
	return [NSString stringWithFormat:@"%@ (%d)", message, code];
}

+ (BOOL)errorCodeOfException:(NSException *)exception matchedCode:(NSInteger)code
{
	BOOL isCodeMatched = NO;
	
	//--Recoverable if retry allow
	NSDictionary *userInfo = [exception userInfo];
	NSError *detectedError = nil;
	
	if (userInfo) {
		detectedError = [userInfo valueForKey:@"error"];
	}
	
	if (detectedError && [detectedError code] == code) {
		isCodeMatched = YES;
	}
	
	return isCodeMatched;
}

@end
