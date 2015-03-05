//
//  RPKLocationSelection.h
//  Kiosk
//
//  Created by PC Nguyen on 1/26/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKSelection.h"

typedef NS_OPTIONS(NSInteger, RPKLocationSourceOptions) {
	LocationSourceNone = 1 << 0,
	LocationSourceKiosk = 1 << 1,
	LocationSourceGoogle = 1 << 2,
	LocationSourceCars = 2 << 3
};

@interface RPKLocationSelection : RPKSelection

@property (nonatomic, assign) RPKLocationSourceOptions enabledSources;

@end
