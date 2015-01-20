//
//  RPKTimedWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKTimedWebViewController.h"

#define kTWVCMaxIdleTime				2*60
#define kTWVCExpirationWaitTime			20

@implementation RPKTimedWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super initWithURL:url]) {
		self.enableToolBar = YES;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.toolBar];
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 70.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
	
	[self.webView addSubview:self.expirationView];
	[self.webView addConstraints:[self.expirationView ul_pinWithInset:UIEdgeInsetsZero]];
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

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	self.loadingView.frame = self.webView.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	self.lastInteractionDate = [NSDate date];
	[self.idleTask start];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.idleTask stop];
}

#pragma mark - Toolbar

- (UIToolbar *)toolBar
{
	if (!_toolBar) {
		_toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		_toolBar.items = @[[self testItem],
						   [self flexibleItem],
						   self.logoutButton];
		[_toolBar setBackgroundColor:[UIColor rpk_defaultBlue]];
		[_toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
		_toolBar.opaque = YES;
		[_toolBar ul_enableAutoLayout];
	}
	
	return _toolBar;
}

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
	[self logout];
}

- (void)logout
{
	/*Subclass Override this*/
}

- (UIBarButtonItem *)testItem
{
	UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithTitle:@"Expire"
																 style:UIBarButtonItemStylePlain
																target:self
																action:@selector(handleTestItemTapped:)];
	return testItem;
}

- (void)handleTestItemTapped:(id)sender
{
	[self displayExpirationMessage];
}

- (UIBarButtonItem *)flexibleItem
{
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	return flexItem;
}

#pragma mark - Expiration

- (RPKExpirationView *)expirationView
{
	if (!_expirationView) {
		_expirationView = [[RPKExpirationView alloc] init];
		_expirationView.timeRemaining = kTWVCExpirationWaitTime;
		_expirationView.alpha = 0.0f;
		_expirationView.backgroundColor = [UIColor clearColor];
		_expirationView.delegate = self;
		[_expirationView ul_enableAutoLayout];
	}
	
	return _expirationView;
}

- (ALScheduledTask *)idleTask
{
	if (!_idleTask) {
		__weak RPKTimedWebViewController *selfPointer = self;
		_idleTask = [[ALScheduledTask alloc] initWithTaskInterval:kTWVCMaxIdleTime taskBlock:^{
			NSTimeInterval idleTime = [selfPointer.lastInteractionDate timeIntervalSinceNow] * (-1);
			if (idleTime > kTWVCMaxIdleTime && selfPointer.expirationView.alpha == 0) {
				[selfPointer displayExpirationMessage];
			}
		}];
	}
	
	return _idleTask;
}

- (void)displayExpirationMessage
{
	[self.webView endEditing:YES];
	[self.view bringSubviewToFront:self.expirationView];
	self.expirationView.alpha = 1.0f;
	self.expirationView.timeRemaining = kTWVCExpirationWaitTime;
	[self.expirationView startCountDown];
}

- (void)hideExpirationMessage
{
	self.lastInteractionDate = [NSDate date];
	self.expirationView.alpha = 0.0f;
	[self.expirationView stopCountDown];
}

#pragma mark - Expiration View Delegate

- (void)expirationViewTimeExpired:(RPKExpirationView *)expirationView
{
	[self logout];
}

- (void)expirationViewDidReceivedTap:(RPKExpirationView *)expirationView
{
	[self hideExpirationMessage];
}

#pragma mark - Loading

- (RPKLoadingView *)loadingView
{
	if (!_loadingView) {
		_loadingView = [[RPKLoadingView alloc] initWithFrame:CGRectZero];
	}
	
	return _loadingView;
}

- (void)showLoading
{
	self.logoutButton.enabled = NO;
	[self.loadingView showFromView:self.webView];
}

- (void)hideLoading
{
	self.logoutButton.enabled = YES;
	[self.loadingView hide];
}

@end
