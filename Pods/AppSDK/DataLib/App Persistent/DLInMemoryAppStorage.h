//
//  DLTempAppStorage.h
//  AppSDK
//
//  Created by PC Nguyen on 10/13/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLAppStorage.h"

@interface DLInMemoryAppStorage : DLAppStorage

+ (instancetype)sharedInstance;

/**
 *  provide read access for the internal data store
 *
 *  @return a dictionary structure of the data store
 */
- (NSDictionary *)dataStore;

@end
