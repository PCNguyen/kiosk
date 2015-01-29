//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 1/14/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKKioskViewController.h"
#import "RPKMaskButton.h"

#define kKVCSubmitDetectMessage				@"KioskSubmitDetect"

@interface RPKKioskViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) RPKMaskButton *submitButton;

@end

@implementation RPKKioskViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super initWithURL:url]) {
		//--modify user agent
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setObject:@"Mozilla/5.0 (iPad; CPU OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"
					   forKey:@"UserAgent"];
		[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
	}
	
	return self;
}

- (void)logout
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loadView
{
	[super loadView];
	
	self.title = @"Leave a Review";
}

- (WKWebViewConfiguration *)webConfiguration
{
	WKUserContentController *userContentController = [WKUserContentController new];
	
	//--add script to attach handler to submit button
	NSString *eventListenScriptText = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"manualSelect"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *eventListenScript = [[WKUserScript alloc] initWithSource:eventListenScriptText
														injectionTime:WKUserScriptInjectionTimeAtDocumentStart
													forMainFrameOnly:YES];
	[userContentController addUserScript:eventListenScript];
	
	WKUserScript *eventScript = [[WKUserScript alloc] initWithSource:@"listenToKioskSubmit();"
													   injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
													forMainFrameOnly:YES];
	[userContentController addUserScript:eventScript];
	
	//--add handler to handle clearing cookies
	[userContentController addScriptMessageHandler:self name:kKVCSubmitDetectMessage];
	
	WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
	configuration.userContentController = userContentController;
	
	return configuration;
}

#pragma mark - Mask Button

- (RPKMaskButton *)submitButton
{
	if (!_submitButton) {
		_submitButton = [[RPKMaskButton alloc] init];
		_submitButton.alpha = 0.0f;
		
		__weak RPKKioskViewController *selfPointer = self;
		_submitButton.actionBlock = ^{
			selfPointer.logoutButton.enabled = NO;
			[selfPointer performSelector:@selector(logout) withObject:nil afterDelay:7.0f];
		};
		
		[_submitButton ul_enableAutoLayout];
		[_submitButton ul_fixedSize:CGSizeMake(235.0f, 50.0f)];
	}
	
	return _submitButton;
}

#pragma mark - WKWebView Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	[self showLoading];
	decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	[self hideLoading];
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	if ([message.name isEqualToString:kKVCSubmitDetectMessage]) {
		[userContentController removeScriptMessageHandlerForName:kKVCSubmitDetectMessage];
		[self showLoading];
		[self performSelector:@selector(logout) withObject:nil afterDelay:7];
	}
}

@end
