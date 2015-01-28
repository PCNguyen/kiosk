//
//  RPKMenuViewController.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKViewController.h"
#import "RPKMenuDataSource.h"

@interface RPKMenuViewController : RPKViewController <ULViewDataBinding>

- (void)validateSources;

@end
