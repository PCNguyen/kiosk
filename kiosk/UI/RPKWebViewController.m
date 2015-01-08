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
	
	[self.view addSubview:self.webView];
	
	if (self.enableToolBar) {
		[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f)]];
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

- (UIWebView *)webView
{
	if (!_webView) {
		_webView = [[UIWebView alloc] init];
		_webView.delegate = self;
		[_webView ul_enableAutoLayout];
	}
	
	return _webView;
}

@end
