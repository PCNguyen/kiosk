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

- (RPReferenceStorage *)preferenceStorage
{
	if (!_preferenceStorage) {
		_preferenceStorage = [RPReferenceStorage sharedCacheAppStorage];
	}
	
	return _preferenceStorage;
}

- (UserConfig *)userConfig
{
	return [self.preferenceStorage loadUserConfig];
}

@end
