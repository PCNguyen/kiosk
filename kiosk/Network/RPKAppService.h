//
//  RPAppService.h
//  Reputation
//
//  Created by PC Nguyen on 5/19/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPKServiceController.h"

typedef void(^AppServiceDataCompletion)(BOOL success, NSError *error, NSArray *items, long long totalCount);
typedef void(^AppServiceActionCompletion)(BOOL success, NSError *error);

@interface RPKAppService : RPKServiceController

- (MobileClient *)serviceClient:(NSString **)correlationID;

@end
