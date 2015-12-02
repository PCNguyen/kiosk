//
//  NSArray+AL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "NSArray+AL.h"

@implementation NSArray (AL)

- (NSString *)al_stringSeparatedByString:(NSString *)separator
{
	NSString *resultString = @"";
	
	for (id object in self) {
		resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@%@", object, separator]];
	}
	
	//--remove last separator
	if (resultString.length > separator.length) {
		resultString = [resultString substringToIndex:resultString.length - separator.length];
	}
	
	return resultString;
}

- (id)al_objectAtIndex:(NSInteger)index
{
	id object = nil;
	
	if (index < [self count]) {
		object = [self objectAtIndex:index];
	}
	
	return object;
}

@end
