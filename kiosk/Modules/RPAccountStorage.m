//
//  RPAccountDataController.m
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAccountStorage.h"

#define kRPAccountStorageUserAccountKey					@"UserDetails"
#define kRPAccountStorageLastUserKey					@"lastUserAccount"

@implementation RPAccountStorage

#pragma mark - User Account

- (void)saveUserAccount:(User *)userAccount
{
	[self saveValue:userAccount forKey:kRPAccountStorageUserAccountKey];
}

- (User *)loadUserAccount
{
	User *userAccount = (User *)[self loadValueForKey:kRPAccountStorageUserAccountKey];
	return userAccount;
}

- (void)savePreviousEmail:(NSString *)emailAccount
{
	[self saveValue:emailAccount forKey:kRPAccountStorageLastUserKey];
}

- (NSString *)loadPreviousEmail
{
	NSString *email = (NSString *)[self loadValueForKey:kRPAccountStorageLastUserKey];
	
	return email;
}

@end
