//
//  UIApplication+RP.h
//  Reputation
//
//  Created by PC Nguyen on 3/18/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (RP)

+ (NSString *)rp_fullServerURLString;

+ (NSString *)rp_mixPannelAPIToken;

+ (NSString *)rp_crashlyticAPIToken;

+ (NSString *)rp_assetPostfix;

+ (NSString *)rp_itunesAppName;

+ (NSString *)rp_itunesAppID;

- (void)rp_addSubviewOnFrontWindow:(UIView *)view;

@end
