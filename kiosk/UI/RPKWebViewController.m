//
//  RPKWebViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/6/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKWebViewController.h"
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
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardWillShowNotification parameter:nil];
}

- (void)loadView
{
	[super loadView];
	
	[self.view addSubview:self.webView];
	
	if (self.enableToolBar) {
		[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsMake(70.0f, 0.0f, 0.0f, 0.0f)]];
	} else {
		[self.view addConstraints:[self.webView ul_pinWithInset:UIEdgeInsetsZero]];
	}
	
	[RPNotificationCenter registerObject:self forNotificationName:UIKeyboardWillShowNotification handler:@selector(handleKeyboardShowNotification:) parameter:nil];
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

#pragma mark - Notification

- (void)handleKeyboardShowNotification:(NSNotification *)notification
{
	[self performSelector:@selector(readjustWebviewScroller) withObject:nil afterDelay:0];
}

- (void)readjustWebviewScroller
{
	self.webView.scrollView.bounds = self.webView.bounds;
}
@end
