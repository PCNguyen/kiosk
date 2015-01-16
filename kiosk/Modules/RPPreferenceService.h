//
//  RPReferenceServiceController.h
//  Reputation
//
//  Created by PC Nguyen on 4/23/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKAppService.h"

typedef void(^RPReferenceServiceConfigCompletion)(BOOL success, NSError *error, UserConfig *userConfig);

@interface RPPreferenceService : RPKAppService

- (void)getUserConfigWithCompletion:(RPReferenceServiceConfigCompletion)completion;

- (void)updateUserSettings:(NSMutableArray *)userSettings completion:(AppServiceDataCompletion)completion;

#pragma mark - Reset

- (void)logoutWithCompletion:(AppServiceActionCompletion)completion;

@end
