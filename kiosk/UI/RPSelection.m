//
//  RPSelectionInfo.m
//  Reputation
//
//  Created by PC Nguyen on 9/4/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPSelection.h"

@implementation RPSelection

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@: SelectionID: %@, SelectionLabel: %@, IsSelected: %@",
			[super description], self.selectionID, self.selectionLabel, (self.isSelected ? @"YES": @"NO")];
}

@end
