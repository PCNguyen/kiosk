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
		self.url = url;
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.webView];
	[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsZero]];
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
		_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
		_webView.navigationDelegate = self;
		[_webView ul_enableAutoLayout];
	}
	
	return _webView;
}

- (WKWebViewConfiguration *)webViewConfiguration
{
	return [WKWebViewConfiguration new];
}

@end
