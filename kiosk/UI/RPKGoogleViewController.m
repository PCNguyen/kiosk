//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibScheduler.h>
#import <SplittingTriangle/SplittingTriangle.h>

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"
#import "RPKExpirationView.h"
#import "RPKMessageView.h"

#define kGVCLogoutQuery				@"logout=1"

@interface RPKGoogleViewController () <RPKExpirationViewDelegate, RPKMessageViewDelegate>

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) RPKExpirationView *expirationView;
@property (nonatomic, strong) RPKMessageView *messageView;
@property (nonatomic, assign) BOOL popupLoaded;
@property (nonatomic, strong) ALScheduledTask *popupTask;
@property (nonatomic, strong) SplittingTriangle *loadingView;

@end

@implementation RPKGoogleViewController

/**
 *  Modify Agent
 */
+ (void)initialize {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
				   forKey:@"UserAgent"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

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
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 60.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
	
	[self.view addSubview:self.messageView];
	[self.messageView ul_fixedSize:CGSizeMake(0.0f, 80.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.messageView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
	[self.webView addSubview:self.expirationView];
	[self.webView addConstraints:[self.expirationView ul_pinWithInset:UIEdgeInsetsZero]];
	
	[self.webView addSubview:self.loadingView];
	[self.loadingView ul_fixedSize:CGSizeMake(200.0f, 200.0f)];
	[self.webView addConstraints:[self.loadingView ul_centerAlignWithView:self.webView]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.popupLoaded = NO;
}

#pragma mark - Override

- (void)loadRequest
{
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:nonCacheRequest];
}

#pragma mark - Toolbar

- (UIToolbar *)toolBar
{
	if (!_toolBar) {
		_toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		_toolBar.items = @[[self testItem],
						   [self flexibleItem],
						   [self logoutItem]];
		[_toolBar ul_enableAutoLayout];
	}
	
	return _toolBar;
}

- (UIBarButtonItem *)logoutItem
{
	UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(handleLogoutItemTapped:)];
	return logoutItem;
}

- (void)handleLogoutItemTapped:(id)sender
{
	[RPKCookieHandler clearCookie];
	
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIBarButtonItem *)testItem
{
	UIBarButtonItem *testItem = [[UIBarButtonItem alloc] initWithTitle:@"Test"
																   style:UIBarButtonItemStylePlain
																  target:self
																  action:@selector(handleTestItemTapped:)];
	return testItem;
}

- (void)handleTestItemTapped:(id)sender
{
	[RPKCookieHandler clearCookie];
	self.popupLoaded = NO;
	[self.webView reload];
	
//	if (self.expirationView.alpha == 0) {
//		self.expirationView.alpha = 0.5f;
//		[self.expirationView startCountDown];
//	} else {
//		self.expirationView.alpha = 0.0f;
//		[self.expirationView stopCountDown];
//		self.expirationView.timeRemaining = 20;
//	}
}

- (UIBarButtonItem *)flexibleItem
{
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	return flexItem;
}

#pragma mark - UIWebview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//--black list domain
	__block BOOL shouldLoad = YES;
	
	NSArray *blackListDomain = @[@"accounts.youtube.com",
								 @"talkgadget.google.com"];
	if ([blackListDomain containsObject:request.URL.host]) {
		shouldLoad = NO;
	}
	
	//--black list segments
	NSArray *blackListSegment = @[@"hangouts", @"blank", @"notifications"];
	[blackListSegment enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger index, BOOL *stop) {
		if ([[request.URL pathComponents] containsObject:segment]) {
			shouldLoad = NO;
			*stop = YES;
		}
	}];
	
	//--black list about:blank
	if (![request.URL host]) {
		shouldLoad = NO;
	}
	
	NSString *widgetSegment = @"widget";
	if ([[request.URL pathComponents] containsObject:widgetSegment]) {
		[self.popupTask stop];
		self.popupLoaded = YES;
	}
	
	if (shouldLoad) {
		NSLog(@"Prepare Load: %@", request.URL);
	}
	
	return shouldLoad;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	if ([webView.request.URL.host isEqualToString:@"accounts.google.com"]) {
		[self showLoading];
		[self hideMessageView];
	} else if ([webView.request.URL.host isEqualToString:@"plus.google.com"]) {
		if (self.popupLoaded) {
			[self hideLoading];
		} else {
			[self showLoading];
			[self hideMessageView];
		}
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	if ([webView.request.URL.host isEqualToString:@"plus.google.com"]) {
		if (!self.popupLoaded) {
			//--inject the function to be called
			NSString *selectScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"manualSelect"
																							   withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			[self.webView stringByEvaluatingJavaScriptFromString:selectScript];
			
			[self.popupTask start];
		} else {
			[self showMessageView];
		}
	}
}

#pragma mark - Expiration View

- (RPKExpirationView *)expirationView
{
	if (!_expirationView) {
		_expirationView = [[RPKExpirationView alloc] init];
		_expirationView.timeRemaining = 20;
		_expirationView.alpha = 0.0f;
		_expirationView.delegate = self;
		[_expirationView ul_enableAutoLayout];
	}
	
	return _expirationView;
}

#pragma mark - Expiration View Delegate

- (void)expirationViewTimeExpired:(RPKExpirationView *)expirationView
{
	[self handleLogoutItemTapped:nil];
}

#pragma mark - Popup Task

- (ALScheduledTask *)popupTask
{
	if (!_popupTask) {
		__weak RPKGoogleViewController *selfPointer = self;
		_popupTask = [[ALScheduledTask alloc] initWithTaskInterval:5 taskBlock:^{
			if (!selfPointer.popupLoaded) {
				[selfPointer executePopupScript];
			}
		}];
		_popupTask.startImmediately = NO;
	}
	
	return _popupTask;
}

- (void)executePopupScript
{
	NSLog(@"Attempt To Display Popup");
	[self.webView stringByEvaluatingJavaScriptFromString:@"displayPopup();"];
}

#pragma mark - Loading

- (SplittingTriangle *)loadingView
{
	if (!_loadingView) {
		_loadingView = [[SplittingTriangle alloc] init];
		[_loadingView setForeColor:[UIColor ul_colorWithR:120.0f G:23.0f B:255.0f A:0.8f]
					  andBackColor:[UIColor clearColor]];
		[_loadingView setClockwise:YES];
		[_loadingView setDuration:2.4f];
		[_loadingView setRadius:25.0f];
		[_loadingView setAlpha:0.0f];
		[_loadingView ul_enableAutoLayout];
	}
	
	return _loadingView;
}

- (void)showLoading
{
	self.loadingView.paused = NO;
	self.loadingView.alpha = 1.0f;
}

- (void)hideLoading
{
	self.loadingView.alpha = 0.0f;
	self.loadingView.paused = YES;
}

#pragma mark - Message View

- (RPKMessageView *)messageView
{
	if (!_messageView) {
		_messageView = [[RPKMessageView alloc] init];
		_messageView.backgroundColor = [UIColor whiteColor];
		_messageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
		_messageView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
		_messageView.layer.shadowRadius = 3.0f;
		_messageView.layer.shadowOpacity = 0.8f;
		_messageView.delegate = self;
		_messageView.alpha = 0.0f;
		[_messageView ul_enableAutoLayout];
	}
	
	return _messageView;
}

- (void)showMessageView
{
	self.messageView.alpha = 1.0f;
}

- (void)hideMessageView
{
	self.messageView.alpha = 0.0f;
}

#pragma mark - Message View Delegate

- (void)messagViewActionTapped:(RPKMessageView *)messageView
{
	self.popupLoaded = NO;
	[self.webView reload];
}

@end
