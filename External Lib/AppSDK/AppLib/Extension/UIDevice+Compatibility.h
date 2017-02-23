//
//  UIDevice+Compatibility.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Compatibility)

#pragma mark - OS Version Compatibility

+ (NSInteger)al_versionMajor;
+ (NSInteger)al_versionMinor;

+ (BOOL)al_compatibleWithMajorVersion:(NSInteger)version;
+ (BOOL)al_matchMajorVersion:(NSInteger)version;

#pragma mark - Screen Size

+ (BOOL)al_isWideScreen;

@end
