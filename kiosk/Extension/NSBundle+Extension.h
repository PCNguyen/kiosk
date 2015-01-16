//
//  NSBundle+Extension.h
//  Reputation
//
//  Created by PC Nguyen on 3/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Extension)

+ (NSString *)ns_appVersion;
+ (NSString *)ns_appBundleID;
+ (NSString *)ns_appAnalyticName;

+ (NSString *)ns_platformID;

+ (BOOL)ns_isFordCustomBuild;

@end
