//
//  RPAccountManager.h
//  Reputation
//
//  Created by PC Nguyen on 3/3/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Mobile.h"

typedef void(^RPAccountManagerSaveCompletion)();

@interface RPAccountManager : NSObject

#pragma mark - Shared

+ (instancetype)sharedManager;

#pragma mark - Accessors

- (User *)userAccount;

- (void)saveUserAccount:(User *)userAccount;

- (NSString *)previousEmail;

#pragma mark - Authentication Helper

- (BOOL)isAuthenticated;

@end
