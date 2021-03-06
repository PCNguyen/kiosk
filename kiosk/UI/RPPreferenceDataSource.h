//
//  RPPreferenceDataSource.h
//  Reputation
//
//  Created by PC Nguyen on 9/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "ULManagedDataSource.h"
#import "RPKPreferenceStorage.h"

@interface RPPreferenceDataSource : ULManagedDataSource

@property (nonatomic, strong) RPKPreferenceStorage *preferenceStorage;

/**
 *  provide a convenient entry point to loadUserConfig from preferenceStorage
 *
 *  @return the saved UserConfig object
 */
- (UserConfig *)userConfig;

@end
