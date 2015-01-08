//
//  RPKWebViewController.h
//  kiosk
//
//  Created by PC Nguyen on 1/6/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RPKViewController.h"
#import "RPKUIKit.h"

@interface RPKWebViewController : RPKViewController <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) BOOL enableToolBar;

- (instancetype)initWithURL:(NSURL *)url;

#pragma mark - Subclass Hook

/**
 *  Load the url request on viewDidLoad
 *	Override this to provide custom request
 */
- (void)loadRequest;

- (WKWebViewConfiguration *)webConfiguration;

@end
