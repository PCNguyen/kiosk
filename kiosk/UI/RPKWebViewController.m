//
//  RPKWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/6/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKWebViewController.h"

@implementation RPKWebViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super init]) {
		_url = url;
		_enableToolBar = NO;
	}
	
	return self;
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
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self loadRequest];
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

@end
