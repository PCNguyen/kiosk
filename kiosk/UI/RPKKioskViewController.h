//
//  RPKKioskViewController.h
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKTimedWebViewController.h"

@class RPKKioskViewController;

@protocol RPKKioskViewControllerDelegate <NSObject>

@optional
- (void)kioskViewControllerShouldClearInformation;

@end

@interface RPKKioskViewController : RPKTimedWebViewController

@property (nonatomic, assign) BOOL kioskOnly;

@property (nonatomic, weak) id <RPKKioskViewControllerDelegate>delegate;

@end
