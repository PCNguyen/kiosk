//
//  UIDevice+Compatibility.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIDevice+Compatibility.h"

@implementation UIDevice (Compatibility)

#pragma mark - OS Version

+ (NSInteger)al_versionMajor
{
    NSInteger majorVersion = [self __versionComponentAtIndex:0];
    
    return majorVersion;
}

+ (NSInteger)al_versionMinor
{
    NSInteger minorVersion = [self __versionComponentAtIndex:1];
    
    return minorVersion;
}

+ (BOOL)al_compatibleWithMajorVersion:(NSInteger)version
{
    BOOL compatible = ([self al_versionMajor] >= version);
    
    return compatible;
}

+ (BOOL)al_matchMajorVersion:(NSInteger)version
{
    BOOL compatible = ([self al_versionMajor] == version);
    
    return compatible;
}

#pragma mark - OS Version Private

+ (NSInteger)__versionComponentAtIndex:(NSInteger)componentIndex
{
    NSInteger componentValue = 0;
    NSArray *versionComponents = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
    
    if ([versionComponents count] > componentIndex) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *componentString = [versionComponents objectAtIndex:componentIndex];
        componentValue = [[numberFormatter numberFromString:componentString] integerValue];
    } else {
        
    }
    
    return componentValue;
}

#pragma mark - Screen Size

+ (BOOL)al_isWideScreen {
	return [[UIScreen mainScreen] bounds].size.height == 568.0f;
}

@end
