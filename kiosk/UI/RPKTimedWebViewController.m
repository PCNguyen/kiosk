//
//  RPKTimedWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKTimedWebViewController.h"
#import "RPKMaskButton.h"

#define kTWVCMaxIdleTime				2*60
#define kTWVCExpirationWaitTime			20

@interface RPKTimedWebViewController ()

@property (nonatomic, strong) RPKMaskButton *maskButton;

@end

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
	
	[self.webView addSubview:self.maskButton];
	[self.webView addConstraints:[self.maskButton ul_pinWithInset:UIEdgeInsetsZero]];
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

- (RPKExpirationViewController *)expirationViewController
{
	if (!_expirationViewController) {
		_expirationViewController = [[RPKExpirationViewController alloc] init];
		_expirationViewController.delegate = self;
	}
	
	return _expirationViewController;
}

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
	[self.expirationViewController startCountDown:kTWVCExpirationWaitTime fromViewController:self];
}

- (void)hideExpirationMessage
{
	self.lastInteractionDate = [NSDate date];
	[self.expirationViewController stopCountDown];
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
	[self hideExpirationMessage];
	[self logout];
}

#pragma mark - Loading

- (void)showLoading
{
	self.logoutButton.enabled = NO;
	[self toggleLoadingView:YES];
}

- (void)hideLoading
{
	self.logoutButton.enabled = YES;
	[self toggleLoadingView:NO];
}

@end
