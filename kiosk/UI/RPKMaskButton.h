//
//  RPKMaskButton.h
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKView.h"

typedef void(^RPKMaskButtonAction)();

@interface RPKMaskButton : RPKView

@property (copy, readwrite) RPKMaskButtonAction actionBlock;

@end
