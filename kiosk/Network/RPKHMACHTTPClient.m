//
//  RPHMACHTTPClient.m
//  Reputation
//
//  Created by PC Nguyen on 3/24/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

#import "RPKHMACHTTPClient.h"

#import "TTransportException.h"
#import "Base64.h"

#import "User+RP.h"
#import "NSBundle+Extension.h"
#import "NSError+RP.h"

@interface RPKHMACHTTPClient ()

@property (nonatomic, strong) NSURL *serverURL;
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSMutableData *requestData;
@property (nonatomic, strong) NSData *responseData;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *authenticationID;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger responseDataOffset;

@end

@implementation RPKHMACHTTPClient

- (id)initWithURL:(NSURL *)serverURL authenticationID:(NSString *)authenticationID
{
	if (self = [self initWithURL:serverURL userAgent:nil timeout:0 user:nil]) {
		_authenticationID = authenticationID;
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)serverURL
			 user:(User *)user
{
	return [self initWithURL:serverURL userAgent:nil timeout:0 user:user];
}

- (id)initWithURL:(NSURL *)serverURL
		userAgent:(NSString *)userAgent
		  timeout:(NSInteger)timeout
			 user:(User *)user
{
	if (self = [super init]) {
		_serverURL = serverURL;
		_userAgent = userAgent;
		_timeOut = timeout;
		_user = user;
	}
	
	return self;
}

#pragma mark - Request

- (NSMutableData *)requestData
{
	if (!_requestData) {
		_requestData = [[NSMutableData alloc] initWithCapacity:1024];
	}
	
	return _requestData;
}

- (NSMutableURLRequest *)request
{
	if (!_request) {
		_request = [[NSMutableURLRequest alloc] initWithURL:self.serverURL];
		[_request setHTTPMethod:@"POST"];
		[_request setValue:@"application/x-thrift" forHTTPHeaderField:@"Content-Type"];
		[_request setValue:@"application/x-thrift" forHTTPHeaderField:@"Accept"];
		[_request setValue:(self.userAgent ? self.userAgent : @"Cocoa/THTTPClient") forHTTPHeaderField: @"User-Agent"];
		[_request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
		
		if (self.timeOut > 0) {
			[_request setTimeoutInterval:self.timeOut];
		}
		
		[_request setValue:[NSBundle ns_appVersion] forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_VERSION_CD]];
		[_request setValue:[NSBundle ns_appBundleID] forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_VERSION_NM]];
		[_request setValue:[NSBundle ns_platformID] forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_PLATFORM]];
		
		if (self.user) {
			[_request setValue:[self.user rp_alias] forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_USER_ID]];
			[_request setValue:[self.user rp_tenantIDString] forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_TENANT_ID]];
			[_request setValue:self.user.keySwapDate forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_KEY_SWAP_DT]];
		}
		
		if ([self.correlationID length] > 0) {
			[_request setValue:self.correlationID forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_CORRELATION_ID]];
		}
		
		//--debug only
		//[_request setValue:@"400" forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_EMULATE_RESP]];
	}
	
	return _request;
}

- (void)signRequestWithHMAC
{
	NSString *md5 = [self calculateMD5Data:self.requestData];
	NSString *timeStamp = [self currentTimeStamp];
	
    NSMutableString *stringToSign = [NSMutableString stringWithString:@""];
    [stringToSign appendString:[self.request.HTTPMethod lowercaseString]];
    [stringToSign appendString:@"\n"];
    [stringToSign appendString:md5];
    [stringToSign appendString:@"\n"];
    [stringToSign appendString:@"application/x-thrift"];
    [stringToSign appendString:@"\n"];
    [stringToSign appendString:timeStamp];
    [stringToSign appendString:@"\n"];
    [stringToSign appendString:self.serverURL.path];

    NSString *hmacSignature = [self hmacSignatureFromString:stringToSign];
	NSString *userId = (self.user ? self.user.email : self.authenticationID);
	NSString *hmacHeader = [NSString stringWithFormat:@"%@:%@", userId, hmacSignature];
    [self.request setValue:hmacHeader forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_HMAC]];
	[self.request setValue:timeStamp forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_DATE]];
	[self.request setValue:md5 forHTTPHeaderField:[MobileCommonConstants HTTP_HEADER_CONTENT_MD5]];
	
}

#pragma mark - TTTransport Protocol

- (int)readAll:(uint8_t *)buffer offset:(int)offset length:(int)length
{
	NSRange range;
	range.location = self.responseDataOffset;
	range.length = length;
	
	if (self.responseData.length > length) {
		[self.responseData getBytes:(buffer + offset) range:range];
		self.responseDataOffset += length;
		
		return length;
	}
	
	return 0;
}

- (void)write:(const uint8_t *)data offset:(unsigned int)offset length:(unsigned int)length
{
	[self.requestData appendBytes:(data+offset) length:length];
}

- (void)flush
{
	[self.request setHTTPBody:self.requestData];
	[self signRequestWithHMAC];
	[self sendRequestAndGetResponse];
}

#pragma mark - Private

- (void)sendRequestAndGetResponse
{
	NSURLResponse *response = nil;
    NSError *error = nil;
    self.responseData = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:&error];
	[self.requestData setLength:0];
	
	if (error.code == kCFURLErrorUserCancelledAuthentication || error.code == kCFURLErrorSecureConnectionFailed) {
		@throw [TTransportException exceptionWithName:@"TTransportException"
											   reason:@"Retry requested"
												error:[NSError rp_networkErrorWithCode:NetworkDomainErrorRetry]];
	
	} else if (self.responseData == nil) {
		
		if (!error) {
			@throw [TTransportException exceptionWithName:@"TTransportException"
												   reason:@"Could not make HTTP request"
													error:[NSError rp_networkErrorWithCode:NetworkDomainErrorEmptyResponse]];
		} else {
			@throw [TTransportException exceptionWithName:@"TTransportException"
												   reason:@"Could not make HTTP request"
													error:[NSError rp_networkErrorWithCode:error.code]];
		}
		
    } else if (![response isKindOfClass: [NSHTTPURLResponse class]]) {
        @throw [TTransportException exceptionWithName:@"TTransportException"
                                               reason:@"Unexpected NSURLResponse type"
												error:[NSError rp_networkErrorWithCode:NetworkDomainErrorInvalidHTTPResponse]];
	} else {
		NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
		
		if ([httpResponse statusCode] != 200) {
			@throw [TTransportException exceptionWithName:@"TTransportException"
												   reason:@"Bad response from HTTP server"
													error:[NSError rp_networkErrorWithCode:[httpResponse statusCode]]];
		}
	}
	
	self.responseDataOffset = 0;
}

- (NSString *)calculateMD5Data:(NSData *)data
{
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, (unsigned int)data.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i] ];
    
	NSString *lower = [output lowercaseString];
    NSString *encoded = [[lower base64EncodedString] lowercaseString];
    
	return encoded;
}

- (NSString *)hmacSignatureFromString:(NSString *)stringToSign
{
	NSString *saltString = [[self class] authenticationSecretKey];
	
	if (self.user) {
		saltString = self.user.userKey;
	}
	
    NSData *saltData = [saltString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *stringToSignData = [stringToSign dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *hash = [NSMutableData dataWithLength:CC_SHA256_DIGEST_LENGTH];
    
	CCHmac(kCCHmacAlgSHA256, saltData.bytes, saltData.length, stringToSignData.bytes, stringToSignData.length, hash.mutableBytes);
    NSString *base64Hash = [hash base64EncodedString];
    
	return base64Hash;
}

- (NSString *)currentTimeStamp
{
	NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-0"]];
    NSString *currentTimeStamp = [[dateFormatter stringFromDate:now] lowercaseString];
	
	return currentTimeStamp;
}

+ (NSString *)authenticationSecretKey
{
	return @"reputation";
}

@end
