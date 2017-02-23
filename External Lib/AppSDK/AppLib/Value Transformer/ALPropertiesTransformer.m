//
//  ULPropertiesTransformer.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ALPropertiesTransformer.h"

NSString *const ALPropertiesTransformerKey = @"ALPropertiesTransformerKey";

@implementation ALPropertiesTransformer

+ (void)load
{
	ALPropertiesTransformer *propertiesTransformer = [[ALPropertiesTransformer alloc] init];
	
	[NSValueTransformer setValueTransformer:propertiesTransformer forName:ALPropertiesTransformerKey];
}

+ (Class)transformedValueClass
{
	return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (id)transformedValue:(id)value
{
	NSMutableArray *selectors = nil;
	
	if ([value isKindOfClass:[NSString class]]) {
		NSArray *component = [value componentsSeparatedByString:@"."];
		if ([component count] > 1) {
			selectors = [NSMutableArray arrayWithArray:component];
			[selectors removeLastObject];
		}
	}
	
	return selectors;
}

+ (NSValueTransformer *)transformer
{
	return [NSValueTransformer valueTransformerForName:ALPropertiesTransformerKey];
}

@end
