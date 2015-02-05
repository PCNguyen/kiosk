//
//  RPAccountManager.m
//  Reputation
//
//  Created by PC Nguyen on 3/3/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAccountManager.h"
#import "RPAccountStorage.h"

@interface RPAccountManager ()

@property (nonatomic, strong) RPAccountStorage *accountStorage;
@property (atomic, strong) User *currentUserAccount;
@property (nonatomic, assign) BOOL shouldRefreshUserAccount;

@end

@implementation RPAccountManager

#pragma mark - Shared

+ (instancetype)sharedManager {
	
	static RPAccountManager *serviceManager;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		
		serviceManager = [[RPAccountManager alloc] init];
		
	});
	
	return serviceManager;
}

- (id)init
{
	if (self = [super init]) {
		self.shouldRefreshUserAccount = NO;
	}
	
	return self;
}

#pragma mark - Accessor

- (User *)userAccount
{
	if (!self.currentUserAccount) {
		self.currentUserAccount = [[self accountStorage] loadUserAccount];
	} else if (self.shouldRefreshUserAccount) {
		self.currentUserAccount = [[self accountStorage] loadUserAccount];
		self.shouldRefreshUserAccount = NO;
	}
	
	return self.currentUserAccount;
}

#pragma mark - Persistence

- (RPAccountStorage *)accountStorage
{
	if (!_accountStorage) {
		_accountStorage = [[RPAccountStorage alloc] init];
	}
	
	return _accountStorage;
}

- (void)saveUserAccount:(User *)userAccount
{
    self.shouldRefreshUserAccount = YES;
	
	if ([[userAccount email] length] > 0) {
		[[self accountStorage] savePreviousEmail:[userAccount email]];
	} else {
		//--backward compatibility		
		User *user = [[self accountStorage] loadUserAccount];
		
		if ([[user email] length] > 0) {
			[[self accountStorage] savePreviousEmail:[user email]];
		}
	}
	
	[[self accountStorage] saveUserAccount:userAccount];
}

- (NSString *)previousEmail
{
	return [[self accountStorage] loadPreviousEmail];
}

#pragma mark - Authentication Helper

- (BOOL)isAuthenticated
{
	BOOL isAuthenticated = ([self userAccount] != nil);
	
	return isAuthenticated;
}

@end
