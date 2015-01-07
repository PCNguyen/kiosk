//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"

#define kGVCLogoutQuery				@"logout=1"

@interface RPKGoogleViewController ()

@property (nonatomic, strong) UIToolbar *toolBar;

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

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.toolBar];
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 60.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
}

#pragma mark - Override

- (void)loadRequest
{
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:nonCacheRequest];
}

- (WKWebViewConfiguration *)webViewConfiguration
{
	NSString *cookiesScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"cookies"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *userScript = [[WKUserScript alloc] initWithSource:cookiesScript
													  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
												   forMainFrameOnly:YES];
	WKUserContentController *userContentController = [WKUserContentController new];
	[userContentController addUserScript:userScript];
	WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
	configuration.userContentController = userContentController;
	
	return configuration;
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
	NSMutableURLRequest *logoutRequest = [NSMutableURLRequest requestWithURL:self.logoutURL
																 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
															 timeoutInterval:30.0f];
	[self.webView loadRequest:logoutRequest];
}

- (UIBarButtonItem *)flexibleItem
{
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
	return flexItem;
}

#pragma mark - Navigation Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	if ([webView.URL isEqual:self.logoutURL]) {
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
