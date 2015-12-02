//
//  ULSetterTransformer.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ALSetterTransformerKey;

@interface ALSetterTransformer : NSValueTransformer

+ (NSValueTransformer *)transformer;

@end
