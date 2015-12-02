//
//  NSUserDefaults+DL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (DL)

/**
 *  save the value to NSUserDefault and synchornize immediately
 *	if value is nil, remove the previously set object from persistent
 *
 *  @param object the object to be stored
 *  @param key    the key to identify the object
 */
+ (void)dl_saveValue:(id)object forKey:(NSString *)key;

/**
 *  load the value stored in NSUserDefault based on specific key
 *
 *  @param key the key to identify the object
 *
 *  @return the stored object
 */
+ (id)dl_loadValueForKey:(NSString *)key;

/**
 *  save the value to NSUserDefault with the option to sync immediately or not
 *	if the value is nil, remove the previously set object from persistent
 *
 *  @param object     the object to be stored
 *  @param key        the key to identify the object
 *  @param shouldSync whether or not we should call synchronize on NSUserDefault
 */
+ (void)dl_saveValue:(id)object forKey:(NSString *)key sync:(BOOL)shouldSync;

/**
 *  remove all saved data in NSUserDefault
 */
+ (void)dl_wipe;

/**
 *  remove all saved data in NSUserDefault with the options to exlude some
 *
 *  @param excludedKeys the key to be kept from wiping
 */
+ (void)dl_wipeExceptKeys:(NSArray *)excludedKeys;

@end
