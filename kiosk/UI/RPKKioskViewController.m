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

@interface RPKKioskViewController ()

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
	[self.toolBar ul_fixedSize:CGSizeMake(0.0f, 100.0f) priority:UILayoutPriorityDefaultHigh];
	[self.view addConstraints:[self.toolBar ul_pinWithInset:UIEdgeInsetsMake(0.0f, 0.0f, kUIViewUnpinInset, 0.0f)]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.kioskURL]];
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
		_webView = [[WKWebView alloc] initWithFrame:CGRectZero];
		[_webView ul_enableAutoLayout];
	}
	
	return _webView;
}

@end
