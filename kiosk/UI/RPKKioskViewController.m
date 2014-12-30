//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RPKKioskViewController.h"
#import "RPKUIKit.h"
#import "RPKCookieHandler.h"

@interface RPKKioskViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *kioskURL;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation RPKKioskViewController

/**
 *  Modify Agent
 */
+ (void)initialize {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
				   forKey:@"UserAgent"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}


- (instancetype)initWithURL:(NSURL *)kioskURL
{
	if (self = [super init]) {
		_kioskURL = kioskURL;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self ul_adjustIOS7Boundaries];
	
	[self.view addSubview:self.webView];
	[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsZero]];
	
	[self.view addSubview:self.toolBar];
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 60.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
}

#pragma mark - Toolbar

- (UIToolbar *)toolBar
{
	if (!_toolBar) {
		_toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		_toolBar.items = @[[self moreTimeItem],
						   [self flexibleItem],
						   [self titleItem],
						   [self flexibleItem],
						   [self logoutItem]];
		[_toolBar ul_enableAutoLayout];
	}
	
	return _toolBar;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.textAlignment = NSTextAlignmentCenter;
		_titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
		_titleLabel.text = @"Google Review";
	}
	
	return _titleLabel;
}

- (UIBarButtonItem *)moreTimeItem
{
	UIBarButtonItem *moreTimeItem = [[UIBarButtonItem alloc] initWithTitle:@"More Time"
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:@selector(handleMoreTimeItemTapped:)];
	return moreTimeItem;
}

- (void)handleMoreTimeItemTapped:(id)sender
{
	NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
													  encoding:NSUTF8StringEncoding
														 error:NULL];
	
	__weak RPKKioskViewController *selfPointer = self;
	
	[self.webView evaluateJavaScript:logoutScript completionHandler:^(id result, NSError *error) {
		[selfPointer.webView reload];
		[RPKCookieHandler clearCookie];
	}];
}

- (UIBarButtonItem *)titleItem
{
	UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
	return titleItem;
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
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (UIBarButtonItem *)flexibleItem
{
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	return flexItem;
}

#pragma mark - Web View

- (WKWebView *)webView
{
	if (!_webView) {
		NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"cookies" withExtension:@"js"]
														  encoding:NSUTF8StringEncoding
															 error:NULL];
		WKUserScript *userScript = [[WKUserScript alloc] initWithSource:logoutScript
														  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
													   forMainFrameOnly:YES];
		WKUserContentController *userContentController = [WKUserContentController new];
		[userContentController addUserScript:userScript];
		WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
		configuration.userContentController = userContentController;
		_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
		_webView.navigationDelegate = self;
		[_webView ul_enableAutoLayout];
	}
	
	return _webView;
}

#pragma mark - Navigation Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
	decisionHandler(WKNavigationResponsePolicyAllow);
}

@end
