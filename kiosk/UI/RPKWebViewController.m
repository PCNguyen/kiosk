//
//  RPKWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/6/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKWebViewController.h"
#import "RPKReachabilityManager.h"
#import "RPNotificationCenter.h"

@implementation RPKWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super init]) {
		_url = url;
		_enableToolBar = NO;
	}
	
	return self;
}

- (void)dealloc
{
	[self unRegisterNotification];
}

- (void)loadView
{
	[super loadView];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																						   target:self
																						   action:@selector(handleDoneButtonTapped:)];
	
	[self.view addSubview:self.webView];
	
	if (self.enableToolBar) {
		[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f)]];
	} else {
		[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsZero]];
	}
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAdministratorGesture:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 3;
	[self.webView addGestureRecognizer:tapGesture];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self registerNotification]
	;
	if ([[RPKReachabilityManager sharedManager] isReachable]) {
		[self loadRequest];
	} else {
		//--revalidate reachability
		[[RPKReachabilityManager sharedManager] reset];
	}
}

- (void)loadRequest
{
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

#pragma mark - Web View

- (WKWebView *)webView
{
	if (!_webView) {
		_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self webConfiguration]];
		_webView.navigationDelegate = self;
		[_webView ul_enableAutoLayout];
	}
	
	return _webView;
}

- (WKWebViewConfiguration *)webConfiguration
{
	return [WKWebViewConfiguration new];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	[self toggleLoadingView:YES];
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	[self toggleLoadingView:NO];
}

- (void)handleDoneButtonTapped:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)registerNotification
{
	[RPNotificationCenter registerObject:self forNotificationName:RPKReachabilityChangedNotification handler:@selector(handleReachabilityChangedNotification:) parameter:nil];
}

- (void)unRegisterNotification
{
	[RPNotificationCenter unRegisterAllNotificationForObject:self];
}

- (void)handleReachabilityChangedNotification:(NSNotification *)notification
{
	if ([[RPKReachabilityManager sharedManager] isReachable]) {
		[self loadRequest];
	}
}

@end
