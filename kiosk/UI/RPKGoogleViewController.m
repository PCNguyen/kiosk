//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"
#import "RPKMessageView.h"

#import "UIColor+RPK.h"

#define kGVCLogoutQuery				@"logout=1"

@interface RPKGoogleViewController () <RPKMessageViewDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) ALScheduledTask *popupTask;
@property (nonatomic, strong) RPKMessageView *messageView;

@property (nonatomic, assign) BOOL popupLoaded;
@property (nonatomic, assign) BOOL cookieCleared;

@end

@implementation RPKGoogleViewController

- (instancetype)initWithURL:(NSURL *)url
{
	if (self = [super initWithURL:url]) {
		//--modify user agent
		NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
		[dictionary setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
					   forKey:@"UserAgent"];
		[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	[self.webView addSubview:self.messageView];
	[self.messageView ul_fixedSize:CGSizeMake(0.0f, 80.0f) priority:UILayoutPriorityDefaultHigh];
	[self.webView addConstraints:[self.messageView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.popupLoaded = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	if (_popupTask) {
		[self.popupTask stop];
	}
}

#pragma mark - Override

- (void)loadRequest
{
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
	[self.webView loadRequest:nonCacheRequest];
}

- (WKWebViewConfiguration *)webConfiguration
{
	//--add script to handle cookies
	NSString *cookiesScriptText = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"cookies"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookiesScriptText
													  injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
												   forMainFrameOnly:YES];
	WKUserContentController *userContentController = [WKUserContentController new];
	[userContentController addUserScript:cookieScript];
	
	//--add script to modify style of the dialog box
	NSString *cssScriptText = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"customStyle"
																						withExtension:@"js"]
													   encoding:NSUTF8StringEncoding
														  error:NULL];
	WKUserScript *cssScript = [[WKUserScript alloc] initWithSource:cssScriptText
													 injectionTime:WKUserScriptInjectionTimeAtDocumentStart
												  forMainFrameOnly:NO];
	[userContentController addUserScript:cssScript];
	
	//--add handler to handle clearing cookies
	[userContentController addScriptMessageHandler:self name:@"CookieClearCompleted"];
	
	WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
	configuration.userContentController = userContentController;
	
	return configuration;
}

- (void)logout
{
	//--in case a count down is in progress
	[self hideExpirationMessage];
	
	//--load the logout request
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
}

#pragma mark - WKWebview Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
	__block BOOL didCancel = NO;
	NSArray *pathComponents = [navigationAction.request.URL pathComponents];
	
	//--black list domain
	NSArray *blackListDomain = @[@"accounts.youtube.com",
								 @"talkgadget.google.com"];
	if ([blackListDomain containsObject:navigationAction.request.URL.host]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		didCancel = YES;
	}
	
	//--black list segments
	NSArray *blackListSegment = @[@"hangouts", @"blank", @"notifications"];
	[blackListSegment enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger index, BOOL *stop) {
		if ([pathComponents containsObject:segment]) {
			decisionHandler(WKNavigationActionPolicyCancel);
			didCancel = YES;
			*stop = YES;
		}
	}];
	
	//--black list about:blank
	if (![navigationAction.request.URL host]) {
		decisionHandler(WKNavigationActionPolicyCancel);
		didCancel = YES;
	}
	
	//--show loading hosts
	NSArray *loadingSegment = @[@"ServiceLogin", @"ServiceLoginAuth"];
	[loadingSegment enumerateObjectsUsingBlock:^(NSString *segment, NSUInteger index, BOOL *stop) {
		if ([pathComponents containsObject:segment]) {
			[self showLoading];
			*stop = YES;
		}
	}];
	
	NSString *widgetSegment = @"widget";
	if ([pathComponents containsObject:widgetSegment]) {
		[self.popupTask stop];
		self.popupLoaded = YES;
		[self hideLoading];
		[self showMessageView];
	}
	
	if (!didCancel) {
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	NSLog(@"%@", webView.URL);
	
	if ([webView.URL.host isEqualToString:@"plus.google.com"]) {
		if (!self.popupLoaded) {
			//--inject the function to be called
			NSString *selectScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"manualSelect"
																							   withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			[self.webView evaluateJavaScript:selectScript completionHandler:NULL];
			
			[self.popupTask startAtDate:[NSDate dateWithTimeIntervalSinceNow:self.popupTask.timeInterval]];
		}
	}
	
	if ([webView.URL isEqual:self.logoutURL]) {
		if (!self.cookieCleared) {
			[self hideMessageView];
			NSLog(@"clearing Cookies ...");
			NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			
			[webView evaluateJavaScript:logoutScript completionHandler:NULL];
		} else {
			[self performSelector:@selector(dismissWebView) withObject:self afterDelay:5.0f];
		}
		
	} else if ([[webView.URL pathComponents] containsObject:@"ServiceLogin"]) {
		[self hideLoading];
	}
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	self.cookieCleared = YES;
	
	[RPKCookieHandler clearCookie];
	
	//--avoid leaking
	[userContentController removeScriptMessageHandlerForName:message.name];
	
	//--to make sure we are clear
	[message.webView loadRequest:[NSURLRequest requestWithURL:self.logoutURL]];
}

- (void)dismissWebView
{
	[self hideLoading];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Popup Task

- (ALScheduledTask *)popupTask
{
	if (!_popupTask) {
		__weak RPKGoogleViewController *selfPointer = self;
		_popupTask = [[ALScheduledTask alloc] initWithTaskInterval:2 taskBlock:^{
			if (!selfPointer.popupLoaded) {
				[selfPointer executePopupScript];
			}
		}];
		_popupTask.startImmediately = NO;
	}
	
	return _popupTask;
}

- (void)executePopupScript
{
	NSLog(@"Attempt To Display Popup");
	[self.webView evaluateJavaScript:@"displayPopup();" completionHandler:^(id result, NSError *error) {
		NSLog(@"%@", error);
	}];
}

#pragma mark - Message View

- (RPKMessageView *)messageView
{
	if (!_messageView) {
		_messageView = [[RPKMessageView alloc] init];
		_messageView.backgroundColor = [UIColor whiteColor];
		_messageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
		_messageView.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
		_messageView.layer.shadowRadius = 3.0f;
		_messageView.layer.shadowOpacity = 0.8f;
		_messageView.delegate = self;
		_messageView.alpha = 0.0f;
		[_messageView ul_enableAutoLayout];
	}
	
	return _messageView;
}

- (void)showMessageView
{
	self.messageView.messageType = MessageReloadPage;
	self.messageView.alpha = 1.0f;
}

- (void)hideMessageView
{
	self.messageView.alpha = 0.0f;
}

#pragma mark - Message View Delegate

- (void)messagViewActionTapped:(RPKMessageView *)messageView
{
	self.popupLoaded = NO;
	[self showLoading];
	[self.webView reload];
}

@end
