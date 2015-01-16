//
//  UserPreference+RP.m
//  Reputation
//
//  Created by PC Nguyen on 10/15/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UserPreference+RP.h"

@implementation UserPreference (RP)

- (NSString *)rp_hash
{
	NSMutableString *compoundHash = [[NSMutableString alloc] init];
	[compoundHash appendString:[NSString stringWithFormat:@"%d", [self.preferenceId hash]]];
	
	for (id selection in self.selectedValues) {
		[compoundHash appendString:[NSString stringWithFormat:@"%d", [selection hash]]];
	}
	
	NSString *hash = [NSString stringWithFormat:@"%d-%d", [compoundHash hash], [self.selectedValues count]];
	return hash;
}

@end
