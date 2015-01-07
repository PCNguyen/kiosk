//
//  RPKMenuDataSource.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "ULViewDataSource.h"
#import "RPKGoogleItem.h"

@interface RPKMenuDataSource : ULViewDataSource

/**
 *  An array of RPKMenuItem
 */
@property (nonatomic, strong) NSArray *menuItems;

- (RPKMenuItem *)menuItemAtIndex:(NSInteger)index;

@end
