//
//  RPKKioskViewController.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKTimedWebViewController.h"

@class RPKGoogleViewController;

@protocol RPKGoogleViewControllerDelegate <NSObject>

- (void)googleViewControllerShouldSignUp:(RPKGoogleViewController *)googleViewController;

@end

@interface RPKGoogleViewController : RPKTimedWebViewController

@property (nonatomic, weak) id<RPKGoogleViewControllerDelegate> delegate;
@property (nonatomic,strong) NSURL *gPlusPageWithReviewUrl;

@end
