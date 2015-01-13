//
//  NSBundle+RPK.h
//  kiosk
//
//  Created by PC Nguyen on 1/13/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (RPK)

/**
 *  the server url to fetch the info
 *
 *  @return server url from info.plist
 */
+ (NSString *)rpk_serverURL;

/**
 *  wrapper to get any key value from info.plist
 *
 *  @param key the key in info.plist
 *
 *  @return the value for the key
 */
+ (id)rpk_infoPlistValueForKey:(NSString *)key;

@end
