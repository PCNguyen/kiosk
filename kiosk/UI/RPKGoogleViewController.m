//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibScheduler.h>

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"
#import "RPKExpirationView.h"
#import "RPKMessageView.h"
#import "RPKLoadingView.h"

#import "UIColor+RPK.h"

#define kGVCLogoutQuery				@"logout=1"

@interface RPKGoogleViewController () <RPKExpirationViewDelegate, RPKMessageViewDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) RPKExpirationView *expirationView;
@property (nonatomic, strong) RPKMessageView *messageView;
@property (nonatomic, assign) BOOL popupLoaded;
@property (nonatomic, assign) BOOL cookieCleared;
@property (nonatomic, strong) ALScheduledTask *popupTask;
@property (nonatomic, strong) RPKLoadingView *loadingView;

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
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 70.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
	
	[self.view addSubview:self.messageView];
	[self.messageView ul_fixedSize:CGSizeMake(0.0f, 80.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.messageView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
	[self.webView addSubview:self.expirationView];
	[self.webView addConstraints:[self.expirationView ul_pinWithInset:UIEdgeInsetsZero]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.popupLoaded = NO;
	
	//--set bar button item color
	[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
							  NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
	 forState:UIControlStateNormal];
	
	[[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],
							  NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}
	 forState:UIControlStateDisabled];
}

- (void)viewWillLayoutSubviews
{
	self.loadingView.frame = self.webView.bounds;
}

#pragma mark - Override

- (void)loadRequest
{
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:nonCacheRequest];
}

- (WKWebViewConfiguration *)webConfiguration
{
	//--add script to handle cookies
	NSString *cookiesScriptText = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"cookies"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookiesScriptText
													  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
												   forMainFrameOnly:YES];
	WKUserContentController *userContentController = [WKUserContentController new];
	[userContentController addUserScript:cookieScript];
	
	//--add script to modify style of the dialog box
	NSString *cssScriptText = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"customStyle"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *cssScript = [[WKUserScript alloc] initWithSource:cssScriptText
													 injectionTime:WKUserScriptInjectionTimeAtDocumentStart
												  forMainFrameOnly:NO];
	[userContentController addUserScript:cssScript];
	
	//--add handler to handle clearing cookies
	[userContentController addScriptMessageHandler:self name:@"CookieClearCompleted"];
	
	WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
	configuration.userContentController = userContentController;
	
	return configuration;
}

#pragma mark - Toolbar

- (UIToolbar *)toolBar
{
	if (!_toolBar) {
		_toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		_toolBar.items = @[[self testItem],
						   [self flexibleItem],
						   [self logoutItem]];
		[_toolBar setBackgroundColor:[UIColor rpk_defaultBlue]];
		[_toolBar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIBarPositionTop barMetrics:UIBarMetricsDefault];
		_toolBar.opaque = YES;
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
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
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
}

- (UIBarButtonItem *)flexibleItem
{
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	return flexItem;
}

#pragma mark - WKWebview Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	__block BOOL didCancel = NO;
	NSArray *pathComponents = [navigationAction.request.URL pathComponents];
	
	//--black list domain
	NSArray *blackListDomain = @[@"accounts.youtube.com",
								 @"talkgadget.google.com"];
	if ([blackListDomain containsObject:navigationAction.request.URL.host]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		didCancel = YES;
	}
	
	//--black list segments
	NSArray *blackListSegment = @[@"hangouts", @"blank", @"notifications"];
	[blackListSegment enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger index, BOOL *stop) {
		if ([pathComponents containsObject:segment]) {
			decisionHandler(WKNavigationActionPolicyCancel);
			didCancel = YES;
			*stop = YES;
		}
	}];
	
	//--black list about:blank
	if (![navigationAction.request.URL host]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		didCancel = YES;
	}
	
	NSString *authSegment = @"ServiceLoginAuth";
	if ([pathComponents containsObject:authSegment]) {
		[self showLoading];
	}
	
	NSString *widgetSegment = @"widget";
	if ([pathComponents containsObject:widgetSegment]) {
		[self.popupTask stop];
		self.popupLoaded = YES;
		[self hideLoading];
		[self showMessageView];
	}
	
	if (!didCancel) {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	NSLog(@"%@", webView.URL);
	
	if ([webView.URL.host isEqualToString:@"plus.google.com"]) {
		if (!self.popupLoaded) {
			//--inject the function to be called
			NSString *selectScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"manualSelect"
																							   withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			[self.webView evaluateJavaScript:selectScript completionHandler:NULL];
			
			[self.popupTask startAtDate:[NSDate dateWithTimeIntervalSinceNow:self.popupTask.timeInterval]];
		}
	}
	
	if ([webView.URL isEqual:self.logoutURL]) {
		if (!self.cookieCleared) {
			[self hideMessageView];
			[self showLoading];
			NSLog(@"clearing Cookies ...");
			NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			
			[webView evaluateJavaScript:logoutScript completionHandler:NULL];
		} else {
			[self hideLoading];
			[self dismissViewControllerAnimated:YES completion:NULL];
		}
	}
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	self.cookieCleared = YES;
	[RPKCookieHandler clearCookie];
	
	//--to make sure we are clear
	[message.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
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
		_popupTask = [[ALScheduledTask alloc] initWithTaskInterval:2 taskBlock:^{
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
	[self.webView evaluateJavaScript:@"displayPopup();" completionHandler:^(id result, NSError *error) {
		NSLog(@"%@", error);
	}];
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
	[self.loadingView showFromView:self.webView];
}

- (void)hideLoading
{
	[self.loadingView hide];
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
	[self showLoading];
	[self.webView reload];
}

@end
