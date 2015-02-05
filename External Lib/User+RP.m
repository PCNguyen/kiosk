//
//  User+RP.m
//  Reputation
//
//  Created by PC Nguyen on 3/24/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "User+RP.h"

@implementation User (RP)

- (NSString *)rp_tenantIDString
{
	NSString *tenantID = [NSString stringWithFormat:@"%lld", self.tenantID];
	return tenantID;
}


- (NSString *)rp_alias
{
	NSString *alias = [NSString stringWithFormat:@"%d", self.id];
	return alias;
}

@end
