//
//  UIApplication+RP.m
//  Reputation
//
//  Created by PC Nguyen on 3/18/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UIApplication+RP.h"

@implementation UIApplication (RP)

+ (NSString *)rp_fullServerURLString
{
	NSString *fullURLString = [NSString stringWithFormat:@"%@:%@/", [self serverURLString], [self portString]];
	
	return fullURLString;
}

+ (NSString *)rp_mixPannelAPIToken
{
	NSString *mixPanelAPIToken = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MixPanel API Token"];
	
	return mixPanelAPIToken;
}

+ (NSString *)rp_crashlyticAPIToken
{
	NSString *crashlyticAPIToken = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Crashlytic API Token"];
	
	return crashlyticAPIToken;
}

+ (NSString *)rp_assetPostfix
{
	NSString *assetPostfix = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Asset Postfix"];
	
	return assetPostfix;
}

+ (NSString *)rp_itunesAppName
{
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Itunes App Name"];
	
	return appName;
}

+ (NSString *)rp_itunesAppID
{
	NSString *appID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Itunes App ID"];
	
	return appID;
}

- (void)rp_addSubviewOnFrontWindow:(UIView *)view
{
	UIWindow *window = self.windows.lastObject;
	[window addSubview:view];
	[window bringSubviewToFront:view];
}

+ (NSString *)rp_kioskURLString
{
	NSString *kioskURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Kiosk Host URL"];
	return kioskURL;
}

+ (NSArray *)rp_administratorCodes
{
	NSArray *administratorCodes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Administrative Code"];
	return administratorCodes;
}

+ (BOOL)rp_googleEnabled
{
	BOOL googleEnabled = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Enable Google"];
	return googleEnabled;
}

#pragma mark - Private

+ (NSString *)serverURLString
{
	NSString *serverURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Server URL"];
	return serverURL;
}

+ (NSString *)portString
{
	NSString *portValue = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Server Port"];
	return portValue;
}

@end
