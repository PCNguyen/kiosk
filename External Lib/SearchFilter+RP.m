//
//  SearchFilter+RP.m
//  Reputation
//
//  Created by PC Nguyen on 7/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "SearchFilter+RP.h"

@implementation SearchFilter (RP)

- (NSString *)reviewHash
{
	NSString *concatHash = [NSString stringWithFormat:@"%d-%d", [self.dateRangeFilterId hash], [self.sentimentFilters hash]];
	
	return concatHash;
}

- (NSString *)socialHash
{
	NSString *concatHash = [NSString stringWithFormat:@"%d-%d", [self.dateRangeFilterId hash], [self.postState hash]];
	
	return concatHash;
}

@end
