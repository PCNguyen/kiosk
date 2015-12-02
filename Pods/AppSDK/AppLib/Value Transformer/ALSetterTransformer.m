//
//  ULSetterTransformer.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALSetterTransformer.h"

NSString *const ALSetterTransformerKey = @"ALSetterTransformerKey";

@implementation ALSetterTransformer

+ (void)load
{
	ALSetterTransformer *setterTransformer = [[ALSetterTransformer alloc] init];
	
	[NSValueTransformer setValueTransformer:setterTransformer forName:ALSetterTransformerKey];
}

+ (Class)transformedValueClass
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
	return YES;
}

- (id)transformedValue:(id)value
{
	NSString *selector = nil;
	
	if ([value isKindOfClass:[NSString class]]) {
		NSArray *component = [value componentsSeparatedByString:@"."];
		if ([component count] > 0) {
			selector = [component lastObject];
			if ([selector rangeOfString:@":"].location == NSNotFound) {
				selector = [NSString stringWithFormat:@"set%@:",[selector capitalizedString]];
			}
		}
	}
	
	return selector;
}

- (id)reverseTransformedValue:(id)value
{
	NSString *selector = nil;
	
	if ([value isKindOfClass:[NSString class]]) {
		NSArray *component = [value componentsSeparatedByString:@"."];
		if ([component count] > 0) {
			selector = [component lastObject];
		}
	}
	
	return selector;
}

+ (NSValueTransformer *)transformer
{
	return [NSValueTransformer valueTransformerForName:ALSetterTransformerKey];
}

@end
