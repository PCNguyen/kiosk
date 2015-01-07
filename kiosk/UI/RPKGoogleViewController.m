//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RPKGoogleViewController.h"
#import "RPKUIKit.h"
#import "RPKCookieHandler.h"

#define kGVCLogoutQuery				@"logout=1"

@interface RPKGoogleViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *kioskURL;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UILabel *titleLabel;

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
	[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f)]];
	
	[self.view addSubview:self.toolBar];
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 60.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.kioskURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:nonCacheRequest];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.titleLabel.frame = CGRectMake(0.0f, 0.0f, self.toolBar.frame.size.width / 2, self.toolBar.frame.size.height);
}

#pragma mark - Toolbar

- (UIToolbar *)toolBar
{
	if (!_toolBar) {
		_toolBar = [[UIToolbar alloc] initWithFrame:CGRectZero];
		_toolBar.items = @[[self flexibleItem],
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
	NSString *logoutURL = [NSString stringWithFormat:@"https://accounts.google.com/ServiceLogin?%@", kGVCLogoutQuery];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logoutURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:request];
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
		NSString *cookiesScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"cookies" withExtension:@"js"]
														  encoding:NSUTF8StringEncoding
															 error:NULL];
		WKUserScript *userScript = [[WKUserScript alloc] initWithSource:cookiesScript
														  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
													   forMainFrameOnly:NO];
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
	if ([webView.URL.host isEqualToString:@"accounts.google.com"] && [webView.URL.query isEqualToString:kGVCLogoutQuery]) {
		NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
														  encoding:NSUTF8StringEncoding
															 error:NULL];
		
		__weak RPKGoogleViewController *selfPointer = self;
		[webView evaluateJavaScript:logoutScript completionHandler:^(id result, NSError *error) {
			[selfPointer dismissViewControllerAnimated:YES completion:NULL];
		}];
	}
	
	decisionHandler(WKNavigationActionPolicyAllow);
}

@end
