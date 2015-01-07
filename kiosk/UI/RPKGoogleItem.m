//
//  RPKGoogleItem.m
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKGoogleItem.h"

#define kGILogoutQuery				@"logout=1"

@implementation RPKGoogleItem

- (NSURL *)logoutURL
{
	if (!_logoutURL) {
		NSString *logoutURLString = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?%@", kGILogoutQuery];
		_logoutURL = [NSURL URLWithString:logoutURLString];
	}
	
	return _logoutURL;
}

@end
