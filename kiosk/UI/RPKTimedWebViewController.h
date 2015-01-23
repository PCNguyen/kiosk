//
//  RPKTimedWebViewController.h
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKWebViewController.h"
#import "RPKExpirationViewController.h"

#import <AppSDK/AppLibScheduler.h>

@interface RPKTimedWebViewController : RPKWebViewController <RPKExpirationViewControllerDelegate>

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;

@property (nonatomic, strong) RPKExpirationViewController *expirationViewController;

@property (nonatomic, strong) ALScheduledTask *idleTask;
@property (atomic, strong) NSDate *lastInteractionDate;

#pragma mark - Subclass Hook

/**
 *  implement the logout mechanism when time expired
 *	or when user explicitly logout
 */
- (void)logout;

#pragma mark - Expiration

- (void)displayExpirationMessage;
- (void)hideExpirationMessage;

#pragma mark - Loading Animation

- (void)showLoading;
- (void)hideLoading;

@end
