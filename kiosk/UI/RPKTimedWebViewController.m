//
//  RPKTimedWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKTimedWebViewController.h"
#import "RPKMaskButton.h"

#define kTWVCMaxIdleTime				60
#define kTWVCExpirationWaitTime			10

@interface RPKTimedWebViewController ()

@property (nonatomic, strong) RPKMaskButton *maskButton;
@property (nonatomic, assign) BOOL loadingShow;

@end

@implementation RPKTimedWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super initWithURL:url]) {
		_shouldTimedOut = YES;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.webView addSubview:self.maskButton];
	[self.webView addConstraints:[self.maskButton ul_pinWithInset:UIEdgeInsetsZero]];
	
	self.navigationItem.rightBarButtonItem = [self logoutButton];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	//--set bar button item color
	[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
							  NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
	 forState:UIControlStateNormal];
	
	[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
							  NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
	 forState:UIControlStateDisabled];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.lastInteractionDate = [NSDate date];
	
	if (self.shouldTimedOut) {
		[self.idleTask start];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (_idleTask) {
		[self.idleTask stop];
	}
}

#pragma mark - Toolbar

- (UIBarButtonItem *)logoutButton
{
	if (!_logoutButton) {
		_logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
														 style:UIBarButtonItemStylePlain
														target:self
														action:@selector(handleLogoutItemTapped:)];
	}
	
	return _logoutButton;
}

- (void)handleLogoutItemTapped:(id)sender
{
	//--override by sublcass
}

#pragma mark - Expiration

- (ALScheduledTask *)idleTask
{
	if (!_idleTask) {
		__weak RPKTimedWebViewController *selfPointer = self;
		_idleTask = [[ALScheduledTask alloc] initWithTaskInterval:kTWVCMaxIdleTime taskBlock:^{
			NSTimeInterval idleTime = [selfPointer.lastInteractionDate timeIntervalSinceNow] * (-1);
			if (idleTime > kTWVCMaxIdleTime && !selfPointer.presentedViewController) {
				[selfPointer displayExpirationMessage];
			}
		}];
	}
	
	return _idleTask;
}

- (void)displayExpirationMessage
{
	[self.webView endEditing:YES];
	self.lastInteractionDate = [NSDate date];
	
	RPKExpirationViewController *expirationViewController = [[RPKExpirationViewController alloc] init];
	expirationViewController.delegate = self;
	[self presentViewController:expirationViewController animated:YES completion:^{
		[expirationViewController startCountDown:kTWVCExpirationWaitTime];
	}];
}

- (RPKMaskButton *)maskButton
{
	if (!_maskButton) {
		_maskButton = [[RPKMaskButton alloc] init];
		_maskButton.alpha = 0.0f;
		
		__weak RPKTimedWebViewController *selfPointer = self;
		_maskButton.actionBlock = ^{
			selfPointer.lastInteractionDate = [NSDate date];
		};
		
		_maskButton.active = YES;
		[_maskButton ul_enableAutoLayout];
	}
	
	return _maskButton;
}

#pragma mark - Expiration View Delegate

- (void)expirationViewControllerTimeExpired:(RPKExpirationViewController *)expirationViewController
{
	//--do nothing, subclass override
}

#pragma mark - Loading

- (void)showLoading
{
	if (!self.loadingShow) {
		self.loadingShow = YES;
		[self toggleLoadingView:YES];
	}
}

- (void)hideLoading
{
	[self toggleLoadingView:NO];
	self.loadingShow = NO;
}

@end
