//
//  DLMOCInteraction.m
//  DataSDK
//
//  Created by PC Nguyen on 1/23/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "DLMOCInteraction_Private.h"

@implementation DLMOCInteraction

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    if (self = [super init]) {
        self.currentMOC = context;
    }
    
    return self;
}

@end
