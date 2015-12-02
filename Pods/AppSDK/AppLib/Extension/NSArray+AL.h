//
//  NSArray+AL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AL)

- (NSString *)al_stringSeparatedByString:(NSString *)separator;

- (id)al_objectAtIndex:(NSInteger)index;

@end
