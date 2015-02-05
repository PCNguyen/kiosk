//
//  NSError+RPK.h
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface NSError (RPK)

+ (NSError *)mx_errorFromResponse:(NSString *)responseError;

+ (NSError *)mx_errorFromNetworkOperation:(AFHTTPRequestOperation *)operation detailError:(NSError *)error;

@end
