//
//  DLAppStorage+RP.h
//  Reputation
//
//  Created by PC Nguyen on 12/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "DLAppStorage.h"

@interface DLAppStorage (RP)

/**
 *  Create a new app storage with the shared cache
 *
 *  @return an instance of DLAppStorage
 */
+ (instancetype)sharedCacheAppStorage;

/**
 *  The cache shared by multiple instance of DLAppStorage
 *
 *  @return the shared cache
 */
+ (NSCache *)sharedCache;

@end
