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
@property (nonatomic, assign) BOOL kioskLoaded;

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

- (void)handleLogoutItemTapped:(id)sender
{
	RPKAnalyticEvent *event = [RPKAnalyticEvent analyticEvent:AnalyticEventSourceLogout];
	[event addProperty:PropertySourceName value:kAnalyticSourceKiosk];
	[event send];

	[self logout];
}

- (void)logout
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loadView
{
	[super loadView];
	
	self.title = @"Leave a Review";
	self.webView.scrollView.backgroundColor = [UIColor ul_colorWithR:1 G:42 B:106 A:1.0f];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.kioskOnly) {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (WKWebViewConfiguration *)webConfiguration
{
	WKUserContentController *userContentController = [WKUserContentController new];
	
	//--add handler to handle submit
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

#pragma mark - Expiration View Delegate

- (void)expirationViewControllerTimeExpired:(RPKExpirationViewController *)expirationViewController
{
	RPKAnalyticEvent *expiredEvent = [RPKAnalyticEvent analyticEvent:AnalyticEventSourceIdle];
	[expiredEvent addProperty:PropertySourceName value:kAnalyticSourceKiosk];
	[expiredEvent send];
	
	[self logout];
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
	RPKAnalyticEvent *sourceLoadedEvent = [RPKAnalyticEvent analyticEvent:AnalyticEventSourceLoaded];
	[sourceLoadedEvent addProperty:PropertySourceName value:kAnalyticSourceKiosk];
	[sourceLoadedEvent send];
	self.kioskLoaded = YES;
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	if ([message.name isEqualToString:kKVCSubmitDetectMessage] && self.kioskLoaded) {
		RPKAnalyticEvent *submitEvent = [RPKAnalyticEvent analyticEvent:AnalyticEventSourceSubmit];
		[submitEvent addProperty:PropertySourceName value:kAnalyticSourceKiosk];
		[submitEvent send];
		
		if (!self.kioskOnly) {
			[self performSelector:@selector(logout) withObject:nil afterDelay:5.0f];
		}
	}
}

@end
