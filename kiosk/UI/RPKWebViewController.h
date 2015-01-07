//
//  RPKWebViewController.h
//  kiosk
//
//  Created by PC Nguyen on 1/6/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RPKUIKit.h"
#import "RPKViewController.h"

@interface RPKWebViewController : RPKViewController <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;;
@property (nonatomic, strong) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

#pragma mark - Subclass Hook

/**
 *  Load the url request on viewDidLoad
 *	Override this to provide custom request
 */
- (void)loadRequest;

/**
 *  Provide the initial configuration for webview
 *	Override this to provide custom configuration
 *
 *  @return the custom configuration
 */
- (WKWebViewConfiguration *)webViewConfiguration;

@end
