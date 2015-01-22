//
//  RPKMenuItem.h
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MenuItemType) {
	MenuTypeGeneric,
	MenuTypeGoogle,
};

@interface RPKMenuItem : NSObject

/**
 *  The URL to be loaded in webview
 */
@property (nonatomic, strong) NSURL *itemURL;

/**
 *  The logo image name
 */
@property (nonatomic, strong) NSString *imageName;

/**
 *  The title for item
 */
@property (nonatomic, strong) NSString *itemTitle;

/**
 *  whether to display secured logo or not
 */
@property (nonatomic, assign) BOOL isSecured;

/**
 *  any specific item to be used
 */
@property (nonatomic, assign) MenuItemType itemType;

@end

