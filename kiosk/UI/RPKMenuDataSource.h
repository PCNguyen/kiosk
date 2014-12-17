//
//  RPKMenuDataSource.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "ULViewDataSource.h"

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
 *  A brief description
 */
@property (nonatomic, strong) NSString *itemDetail;

@end

@interface RPKMenuDataSource : ULViewDataSource

/**
 *  An array of RPKMenuItem
 */
@property (nonatomic, strong) NSArray *menuItems;

- (RPKMenuItem *)menuItemAtIndex:(NSInteger)index;

@end
