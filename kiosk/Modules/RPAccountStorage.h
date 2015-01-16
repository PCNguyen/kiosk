//
//  RPAccountDataController.h
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "DLAppStorage.h"
#import "Mobile.h"

@interface RPAccountStorage : DLAppStorage

- (void)saveUserAccount:(User *)userAccount;

- (User *)loadUserAccount;

- (void)savePreviousEmail:(NSString *)emailAccount;

- (NSString *)loadPreviousEmail;

@end
