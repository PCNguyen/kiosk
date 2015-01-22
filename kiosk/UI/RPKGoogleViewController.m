//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"
#import "RPKSecuredView.h"
#import "RPKReloadView.h"
#import "RPKGoogleMessage.h"
#import "RPKMaskButton.h"
#import "RPNotificationCenter.h"
#import "UIApplication+RP.h"

#import <AppSDK/AppLibExtension.h>

#define kGVCLogoutQuery				@"logout=1"
#define kGV
@interface RPKGoogleViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) ALScheduledTask *popupTask;
@property (nonatomic, strong) RPKSecuredView *securedView;
@property (nonatomic, strong) RPKReloadView *reloadView;
@property (nonatomic, strong) RPKGoogleMessage *googleMessage;
@property (nonatomic, strong) RPKMaskButton *submitButton;
@property (nonatomic, strong) RPKMaskButton *cancelButton;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) BOOL popupLoaded;
@property (nonatomic, assign) BOOL cookieCleared;

@end

@implementation RPKGoogleViewController

- (void)dealloc
{
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardDidShowNotification parameter:nil];
}

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super initWithURL:url]) {
		//--modify user agent
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
					   forKey:@"UserAgent"];
		[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];

	self.webView.scrollView.scrollEnabled = NO;
	
	[self.webView addSubview:self.coverView];
	[self.webView addConstraints:[self.coverView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
	
	[self.webView addSubview:self.securedView];
	[self.webView addConstraints:[self.securedView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 80.0f, 100.0f, 80.0f)]];
	
	[self.webView addSubview:self.reloadView];
	[self.webView addConstraints:[self.reloadView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 20.0f, kUIViewAquaDistance, kUIViewAquaDistance)]];
	
	[self.webView addSubview:self.googleMessage];
	[self.webView addConstraints:[self.googleMessage ul_pinWithInset:UIEdgeInsetsMake(50.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
	
	[self.webView addSubview:self.submitButton];
	[self.webView addConstraints:[self.submitButton ul_pinWithInset:UIEdgeInsetsMake(665.0f, 42.0f, kUIViewUnpinInset, kUIViewUnpinInset)]];

}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.popupLoaded = NO;
	
	[RPNotificationCenter registerObject:self forNotificationName:UIKeyboardDidShowNotification handler:@selector(handleKeyboardShowNotification:) parameter:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (_popupTask) {
		[self.popupTask stop];
	}
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

- (void)logout
{
	//--in case a count down is in progress
	[self hideExpirationMessage];
	
	//--load the logout request
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
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
	
	//--show loading hosts
	NSArray *loadingSegment = @[@"ServiceLogin", @"ServiceLoginAuth"];
	[loadingSegment enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger index, BOOL *stop) {
		if ([pathComponents containsObject:segment]) {
			[self showLoading];
			*stop = YES;
		}
	}];
	
	if ([navigationAction.request.URL.host isEqualToString:@"plus.google.com"]) {
		[self toggleCustomViewForLoginScreen:NO];
	}
	
	NSString *widgetSegment = @"widget";
	if ([pathComponents containsObject:widgetSegment]) {
		[self.popupTask stop];
		self.popupLoaded = YES;
		self.submitButton.active = YES;
		
		[self hideLoading];
		[self toggleCustomViewForGooglePage:YES];
	}
	
	if (!didCancel) {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
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
			[self toggleCustomViewForGooglePage:NO];
			[self toggleCustomViewForLoginScreen:YES];
			NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			
			[webView evaluateJavaScript:logoutScript completionHandler:NULL];
		} else {
			[self performSelector:@selector(dismissWebView) withObject:self afterDelay:5.0f];
		}
		
	} else if ([[webView.URL pathComponents] containsObject:@"ServiceLogin"]) {
		[self hideLoading];
		[self toggleCustomViewForLoginScreen:YES];
	}
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	self.cookieCleared = YES;
	
	[RPKCookieHandler clearCookie];
	
	//--avoid leaking
	[userContentController removeScriptMessageHandlerForName:message.name];
	
	//--to make sure we are clear
	[message.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
}

- (void)dismissWebView
{
	[self hideLoading];
	[self dismissViewControllerAnimated:YES completion:NULL];
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
	[self.webView evaluateJavaScript:@"displayPopup();" completionHandler:NULL];
}

#pragma mark - Reload View

- (void)toggleCustomViewForGooglePage:(BOOL)visible
{
	self.reloadView.alpha = visible;
	self.googleMessage.alpha = visible;
}

- (void)handleReloadViewTapped:(id)sender
{
	self.popupLoaded = NO;
	[self showLoading];
	[self.webView reload];
}

#pragma mark - Secured View

- (RPKSecuredView *)securedView
{
	if (!_securedView) {
		_securedView = [[RPKSecuredView alloc] init];
		_securedView.backgroundColor = [UIColor clearColor];
		[_securedView setLockBackgroundColor:[UIColor whiteColor]];
		[_securedView ul_enableAutoLayout];
		[_securedView ul_fixedSize:CGSizeMake(0.0f, 110.0f) priority:UILayoutPriorityDefaultHigh];
		
		NSString *securedMessage = NSLocalizedString(@"We never save or share your personal information.", nil);
		NSString *boldText = NSLocalizedString(@"never", nil);
		NSMutableAttributedString *attributedMessage = [securedMessage al_attributedStringWithFont:[UIFont rpk_fontWithSize:20.0f] textColor:[UIColor rpk_mediumGray]];
		[attributedMessage addAttribute:NSFontAttributeName value:[UIFont rpk_extraBoldFontWithSize:20.0f] range:[securedMessage rangeOfString:boldText]];
		[_securedView setSecuredMessage:attributedMessage];
		_securedView.alpha = 0.0f;
	}
	
	return _securedView;
}

- (void)toggleCustomViewForLoginScreen:(BOOL)visible
{
	self.securedView.alpha = visible;
	self.coverView.alpha = visible;
}

#pragma mark - Cover View

- (UIView *)coverView
{
	if (!_coverView) {
		_coverView = [[UIView alloc] init];
		_coverView.backgroundColor = [UIColor whiteColor];
		_coverView.alpha = 0.0f;
		[_coverView ul_enableAutoLayout];
		[_coverView ul_fixedSize:CGSizeMake(0.0f, 400.0f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _coverView;
}

#pragma mark - Reload View

- (RPKReloadView *)reloadView
{
	if (!_reloadView) {
		_reloadView = [[RPKReloadView alloc] init];
		_reloadView.backgroundColor = [UIColor clearColor];
		_reloadView.alpha = 0.0f;
		[_reloadView ul_enableAutoLayout];
		[_reloadView ul_fixedSize:CGSizeMake(0.0f, 40.0f) priority:UILayoutPriorityDefaultHigh];
		[_reloadView ul_addTapGestureWithTarget:self action:@selector(handleReloadViewTapped:)];
	}
	
	return _reloadView;
}

#pragma mark - Google Message

- (RPKGoogleMessage *)googleMessage
{
	if (!_googleMessage) {
		_googleMessage = [[RPKGoogleMessage alloc] init];
		_googleMessage.backgroundColor = [UIColor clearColor];
		_googleMessage.alpha = 0.0f;
		[_googleMessage ul_enableAutoLayout];
		[_googleMessage ul_fixedSize:CGSizeMake(0.0f, 100.0f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _googleMessage;
}

#pragma mark - Submit Button

- (RPKMaskButton *)submitButton
{
	if (!_submitButton) {
		_submitButton = [[RPKMaskButton alloc] init];
		_submitButton.alpha = 0.0f;
		_submitButton.actionBlock = ^{
			NSLog(@"Submit");
		};
		
		_submitButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5f];
		[_submitButton ul_enableAutoLayout];
		[_submitButton ul_fixedSize:CGSizeMake(120.0f, 42.0f)];
	}
	
	return _submitButton;
}

#pragma mark - Notification

- (void)handleKeyboardShowNotification:(NSNotification *)notification
{
//	UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(450, 800.0f, 100.0f, 100.0f)];
//	coverView.backgroundColor = [UIColor redColor];
//	[[UIApplication sharedApplication] rp_addSubviewOnFrontWindow:coverView];
}

- (void)readjustWebviewScroller
{
	self.webView.scrollView.bounds = self.webView.bounds;
}

@end
