//
//  RPPreferenceDataSource.m
//  Reputation
//
//  Created by PC Nguyen on 9/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPPreferenceDataSource.h"

@implementation RPPreferenceDataSource

- (void)configureNonBindingProperty
{
	[super configureNonBindingProperty];
	
	[self ignoreUpdateProperty:@selector(preferenceStorage)];
}

- (RPKPreferenceStorage *)preferenceStorage
{
	if (!_preferenceStorage) {
		_preferenceStorage = [RPKPreferenceStorage sharedCacheAppStorage];
	}
	
	return _preferenceStorage;
}

- (UserConfig *)userConfig
{
	return [self.preferenceStorage loadUserConfig];
}

@end
