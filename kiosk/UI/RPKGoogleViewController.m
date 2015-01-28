//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKGoogleViewController.h"
#import "RPKCookieHandler.h"
#import "RPKSecuredView.h"
#import "RPKReloadView.h"
#import "RPKGoogleMessage.h"
#import "RPKMaskButton.h"
#import "RPKGoogleThankYou.h"

#import "RPNotificationCenter.h"
#import "UIApplication+RP.h"

#import <AppSDK/AppLibExtension.h>

#define kGVCLogoutURL				@"https://accounts.google.com/ServiceLogin?logout=1"

#define kGVCKeyboardHideLockSize		CGSizeMake(58.0f, 58.0f)
#define kGVCKeyboardGoButtonSize		CGSizeMake(100.0f, 57.0f)

#define kGVCClearCookieMessage			@"CookieClearCompleted"
#define kGVCSignupDetectMessage			@"SignupDetect"

#define kGVCMaxPopupTry					10

typedef NS_ENUM(NSInteger, RPKGooglePage) {
	GooglePageUnknown,
	
	GooglePageAccount,
	GooglePageAccountClearCookie,
	GooglePageAccountLogin,
	GooglePageAccountAuthentication,

	GooglePageGplus,
	GooglePageGplusSignup,
	GooglePageGplusAbout,
	GooglePageGplusWidget,
	
	GooglePageCustomError,
};

@interface RPKGoogleViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) ALScheduledTask *popupTask;

/**
 *  Background view for login page
 */
@property (nonatomic, strong) RPKSecuredView *securedView;
@property (nonatomic, strong) UIBarButtonItem *backButton;


/**
 *  Background view for widget page
 */
@property (nonatomic, strong) RPKReloadView *reloadView;
@property (nonatomic, strong) RPKGoogleMessage *googleMessage;
@property (nonatomic, strong) NSLayoutConstraint *googleTop;
@property (nonatomic, strong) RPKGoogleThankYou *googleThankyou;

/**
 *  Mask buttons for widget page
 */
@property (nonatomic, strong) RPKMaskButton *submitButton;
@property (nonatomic, strong) NSLayoutConstraint *submitTop;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) NSInteger popupTryCount;

/**
 *  view to mask the keyboard
 */
@property (nonatomic, strong) UIImageView *hideKeyboardLock;

/**
 *  Cover the bottom half of the login screen
 */
@property (nonatomic, strong) UIView *coverView;

/**
 *  Page Identification
 */
@property (nonatomic, assign) RPKGooglePage pageWillLoad;
@property (nonatomic, assign) RPKGooglePage pageDidLoad;

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

	self.title = @"Leave a Review";	
	self.webView.scrollView.scrollEnabled = NO;
	
	[self.webView addSubview:self.coverView];
	[self.webView addConstraints:[self.coverView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 0.0f, 0.0f, 0.0f)]];
	
	[self.webView addSubview:self.securedView];
	[self.webView addConstraints:[self.securedView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 80.0f, 100.0f, 80.0f)]];
	
	[self.webView addSubview:self.reloadView];
	[self.webView addConstraints:[self.reloadView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 20.0f, kUIViewAquaDistance, kUIViewAquaDistance)]];
	
	[self.webView addSubview:self.googleMessage];
	self.googleTop = [NSLayoutConstraint constraintWithItem:self.googleMessage
												  attribute:NSLayoutAttributeTop
												  relatedBy:NSLayoutRelationEqual
													 toItem:self.webView
												  attribute:NSLayoutAttributeTop
												 multiplier:1.0f
												   constant:50.0f];
	[self.webView addConstraint:self.googleTop];
	[self.webView ul_addConstraints:[self.googleMessage ul_pinWithInset:UIEdgeInsetsMake(50.0f, 0.0f, kUIViewUnpinInset, 0.0f)]
						   priority:(UILayoutPriorityRequired - 1)];
	
	[self.webView addSubview:self.submitButton];
	self.submitTop = [NSLayoutConstraint constraintWithItem:self.submitButton
												  attribute:NSLayoutAttributeTop
												  relatedBy:NSLayoutRelationEqual
													 toItem:self.webView
												  attribute:NSLayoutAttributeTop
												 multiplier:1.0f
												   constant:665.0f];
	[self.webView addConstraint:self.submitTop];
	[self.webView ul_addConstraints:[self.submitButton ul_pinWithInset:UIEdgeInsetsMake(665.0f, 42.0f, kUIViewUnpinInset, kUIViewUnpinInset)]
						   priority:(UILayoutPriorityRequired - 1)];
	
	[self.webView addSubview:self.cancelButton];
	[self.webView addConstraints:[self.cancelButton ul_horizontalAlign:NSLayoutFormatAlignAllCenterY withView:self.submitButton distance:10.0f leftToRight:NO]];
	
	[self.webView addSubview:self.googleThankyou];
	[self.webView addConstraints:[self.googleThankyou ul_pinWithInset:UIEdgeInsetsZero]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.popupTryCount = 0;
	
	[self registerNotification];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self removeKeyboardMask];
	
	if (_popupTask) {
		[self.popupTask stop];
	}
}

#pragma mark - Override

- (void)loadRequest
{
	[self loadURLString:kGVCLogoutURL];
}

- (void)loadURLString:(NSString *)urlText
{
	NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlText]
																		cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
																	timeoutInterval:30.0f];
	nonCacheRequest.HTTPShouldHandleCookies = NO;
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
	[userContentController addScriptMessageHandler:self name:kGVCClearCookieMessage];
	
	//--add handler to handle no gplus account
	[userContentController addScriptMessageHandler:self name:kGVCSignupDetectMessage];
	
	WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
	configuration.userContentController = userContentController;
	
	return configuration;
}

- (void)logout
{
	//--in case a count down is in progress
	[self hideExpirationMessage];
	
	//--disable mask button
	self.submitButton.active = NO;
	
	[self removeKeyboardMask];
	[self unRegisterNotification];
	
	[self dismissWebView];
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
	
	if (!didCancel) {
		self.pageWillLoad = [self googlePageForURL:navigationAction.request.URL];
		decisionHandler(WKNavigationActionPolicyAllow);
	}
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	self.pageDidLoad = [self googlePageForURL:webView.URL];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
	NSLog(@"%@", error);
	self.pageDidLoad = [self googlePageForURL:webView.URL];
}

#pragma mark - WebView Helper

- (RPKGooglePage)googlePageForURL:(NSURL *)url
{
	if (url) {
		NSArray *pathComponents = [url pathComponents];
		
		if ([[url host] isEqualToString:@"accounts.google.com"]) {
			
			if ([pathComponents containsObject:@"ServiceLogin"]) {
				
				if ([[url absoluteString] isEqualToString:kGVCLogoutURL]) {
					return GooglePageAccountClearCookie;
				} else {
					return GooglePageAccountLogin;
				}
				
			} else if ([pathComponents containsObject:@"ServiceLoginAuth"]) {
				return GooglePageAccountAuthentication;
			} else {
				return GooglePageAccount;
			}
		}
		
		if ([[url host] isEqualToString:@"plus.google.com"]) {
			if ([pathComponents containsObject:@"about"] || [[url query] rangeOfString:@"review=1"].location != NSNotFound) {
				return GooglePageGplusAbout;
			} else if ([pathComponents containsObject:@"widget"]) {
				return GooglePageGplusWidget;
			}
		}
	}
	
	return GooglePageUnknown;
}

- (void)setPageWillLoad:(RPKGooglePage)pageWillLoad
{
	_pageWillLoad = pageWillLoad;
	
	switch (pageWillLoad) {
		case GooglePageUnknown:
			break; //--do nothing for background validation
			
		case GooglePageAccount: //--show hide loading for generic account pages
			[self showLoading];
			break;
		
		case GooglePageAccountClearCookie:
			[self showLoading];
			break;
		
		case GooglePageAccountLogin: //--same cycle with clear cookie, so do nothing
			break;
			
		case GooglePageAccountAuthentication:
			[self toggleCustomViewForLoginScreen:NO];
			[self showLoading];
			break;
			
		case GooglePageGplus:
			[self showLoading];
			break;
		
		case GooglePageGplusSignup: //--javascript, we don't have will load event for this
			break;
			
		case GooglePageGplusAbout:
			[self showLoading];
			break;
		
		case GooglePageGplusWidget:
			[self.popupTask stop];
			[self.submitButton setActive:YES];
			[self hideLoading];
			[self toggleCustomViewForGooglePage:YES];
			break;
	
		case GooglePageCustomError: //--javascript, we don't have will load event for this
			break;
			
		default:
			break;
	}
}

- (void)setPageDidLoad:(RPKGooglePage)pageDidLoad
{
	_pageDidLoad = pageDidLoad;
	
	switch (pageDidLoad) {
		case GooglePageUnknown:
			break;
			
		case GooglePageAccount:
			[self hideLoading];
			break;
			
		case GooglePageAccountClearCookie: {
			NSString *logoutScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"deleteCookies" withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			
			[self.webView evaluateJavaScript:logoutScript completionHandler:NULL];
			[self toggleCustomViewForLoginScreen:YES];
		} break;
			
		case GooglePageAccountLogin:
			[self hideLoading];
			break;
			
		case GooglePageAccountAuthentication: //--if we land here mean login fail
			[self toggleCustomViewForLoginScreen:YES];
			[self hideLoading];
			break;
		
		case GooglePageGplus:
			break;
			
		case GooglePageGplusAbout: {
			//--inject the function to be called
			NSString *selectScript = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"manualSelect" withExtension:@"js"]
															  encoding:NSUTF8StringEncoding
																 error:NULL];
			[self.webView evaluateJavaScript:selectScript completionHandler:NULL];
			[self.popupTask startAtDate:[NSDate dateWithTimeIntervalSinceNow:self.popupTask.timeInterval]];
		} break;
		
		case GooglePageGplusSignup:
			[self.popupTask stop];
			[self hideLoading];
			[self zoomContent];
			break;
		
		case GooglePageGplusWidget: //--we don't have widget did load hook
			break;
			
		case GooglePageCustomError:
			[self.popupTask stop];
			[self hideLoading];
			break;
			
		default:
			break;
	}
}

- (void)dismissWebView
{
	[self hideLoading];
	
	//--remove message handler to avoid leaking
	[self.webView.configuration.userContentController removeScriptMessageHandlerForName:kGVCClearCookieMessage];
	[self.webView.configuration.userContentController removeScriptMessageHandlerForName:kGVCSignupDetectMessage];

	[self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Message Handler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
	if ([message.name isEqualToString:kGVCClearCookieMessage]) {
		[RPKCookieHandler clearCookie];

		//--load the actual request after cookie clearing
		NSMutableURLRequest *nonCacheRequest = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30.0f];
		[self.webView loadRequest:nonCacheRequest];
	} else if ([message.name isEqualToString:kGVCSignupDetectMessage]) {
		self.pageDidLoad = GooglePageGplusSignup;
	}
}

#pragma mark - Popup Task

- (ALScheduledTask *)popupTask
{
	if (!_popupTask) {
		__weak RPKGoogleViewController *selfPointer = self;
		_popupTask = [[ALScheduledTask alloc] initWithTaskInterval:2 taskBlock:^{
			if (selfPointer.pageWillLoad != GooglePageGplusWidget) {
				[selfPointer executePopupScript];
			}
		}];
		_popupTask.startImmediately = NO;
	}
	
	return _popupTask;
}

- (void)executePopupScript
{
	self.popupTryCount++;
	if (self.popupTryCount > kGVCMaxPopupTry) {
		self.pageDidLoad = GooglePageCustomError;
	} else {
		[self.webView evaluateJavaScript:@"displayPopup();" completionHandler:NULL];
		[self.webView evaluateJavaScript:@"detectNoGplus();" completionHandler:NULL];
	}
}

#pragma mark - Login Page Custom Views

- (UIView *)coverView
{
	if (!_coverView) {
		_coverView = [[UIView alloc] init];
		_coverView.backgroundColor = [UIColor whiteColor];
		_coverView.alpha = 0.0f;
		[_coverView ul_enableAutoLayout];
		[_coverView ul_fixedSize:CGSizeMake(0.0f, 400.0f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _coverView;
}

- (RPKSecuredView *)securedView
{
	if (!_securedView) {
		_securedView = [[RPKSecuredView alloc] init];
		_securedView.backgroundColor = [UIColor clearColor];
		[_securedView setLockBackgroundColor:[UIColor whiteColor]];
		[_securedView ul_enableAutoLayout];
		[_securedView ul_fixedSize:CGSizeMake(0.0f, 110.0f) priority:UILayoutPriorityDefaultHigh];
		
		NSString *securedMessage = NSLocalizedString(@"We never save or share your personal information.", nil);
		NSString *boldText = NSLocalizedString(@"never", nil);
		NSMutableAttributedString *attributedMessage = [securedMessage al_attributedStringWithFont:[UIFont rpk_fontWithSize:20.0f] textColor:[UIColor rpk_mediumGray]];
		[attributedMessage addAttribute:NSFontAttributeName value:[UIFont rpk_extraBoldFontWithSize:20.0f] range:[securedMessage rangeOfString:boldText]];
		[_securedView setSecuredMessage:attributedMessage];
		_securedView.alpha = 0.0f;
	}
	
	return _securedView;
}

- (UIBarButtonItem *)backButton
{
	if (!_backButton) {
		UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_back.png"]];
		backImageView.contentMode = UIViewContentModeScaleAspectFit;
		backImageView.userInteractionEnabled = YES;
		[backImageView ul_addTapGestureWithTarget:self action:@selector(handleBackButtonTapped:)];
		CGRect frame = backImageView.frame;
		frame.size = CGSizeMake(20.0f, 25.0f);
		backImageView.frame = frame;
		_backButton = [[UIBarButtonItem alloc] initWithCustomView:backImageView];
	}
	
	return _backButton;
}

- (void)handleBackButtonTapped:(id)sender
{
	[self dismissWebView];
}

- (void)toggleCustomViewForLoginScreen:(BOOL)visible
{
	self.securedView.alpha = visible;
	self.coverView.alpha = visible;
	
	if (visible) {
		self.navigationItem.leftBarButtonItem = self.backButton;
	} else {
		self.navigationItem.leftBarButtonItem = nil;
	}
}

#pragma mark - Google Page Custom View

- (void)toggleCustomViewForGooglePage:(BOOL)visible
{
	self.reloadView.alpha = visible;
	self.googleMessage.alpha = visible;
	self.cancelButton.alpha = visible;
}

- (void)handleReloadViewTapped:(id)sender
{
	self.popupTryCount = 0;
	[self.webView reload];
}

- (RPKReloadView *)reloadView
{
	if (!_reloadView) {
		_reloadView = [[RPKReloadView alloc] init];
		_reloadView.backgroundColor = [UIColor clearColor];
		_reloadView.alpha = 0.0f;
		[_reloadView ul_enableAutoLayout];
		[_reloadView ul_fixedSize:CGSizeMake(0.0f, 40.0f) priority:UILayoutPriorityDefaultHigh];
		[_reloadView ul_addTapGestureWithTarget:self action:@selector(handleReloadViewTapped:)];
	}
	
	return _reloadView;
}

- (RPKGoogleMessage *)googleMessage
{
	if (!_googleMessage) {
		_googleMessage = [[RPKGoogleMessage alloc] init];
		_googleMessage.backgroundColor = [UIColor clearColor];
		_googleMessage.alpha = 0.0f;
		[_googleMessage ul_enableAutoLayout];
		[_googleMessage ul_fixedSize:CGSizeMake(0.0f, 100.0f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _googleMessage;
}

- (RPKMaskButton *)submitButton
{
	if (!_submitButton) {
		_submitButton = [[RPKMaskButton alloc] init];
		_submitButton.alpha = 0.0f;
		
		__weak RPKGoogleViewController *selfPointer = self;
		_submitButton.actionBlock = ^{
			[selfPointer removeKeyboardMask];
			selfPointer.logoutButton.enabled = NO;
			[selfPointer performSelector:@selector(displayThankyouPage) withObject:nil afterDelay:0.5f];
			[selfPointer performSelector:@selector(logout) withObject:nil afterDelay:7.0f];
		};
		
		[_submitButton ul_enableAutoLayout];
		[_submitButton ul_fixedSize:CGSizeMake(120.0f, 42.0f)];
	}
	
	return _submitButton;
}

- (UIButton *)cancelButton
{
	if (!_cancelButton) {
		_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_cancelButton.alpha = 0.0f;
		[_cancelButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
		[_cancelButton addTarget:self action:@selector(handleCancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[_cancelButton ul_enableAutoLayout];
		[_cancelButton ul_fixedSize:CGSizeMake(120.0f, 42.0f)];
	}
	
	return _cancelButton;
}

- (RPKGoogleThankYou *)googleThankyou
{
	if (!_googleThankyou) {
		_googleThankyou = [[RPKGoogleThankYou alloc] init];
		_googleThankyou.alpha = 0.0f;
		[_googleThankyou ul_enableAutoLayout];
	}
	
	return _googleThankyou;
}

- (void)handleCancelButtonTapped:(id)sender
{
	[self removeKeyboardMask];
	[self logout];
}

- (void)displayThankyouPage
{
	[UIView animateWithDuration:1.0f animations:^{
		self.googleThankyou.alpha = 1.0f;
	} completion:^(BOOL finished) {
		[self showLoading];
	}];
}

- (void)hideThankyouPage
{
	self.googleThankyou.alpha = 0.0f;
}

#pragma mark - Keyboard Cover View

- (CGRect)hideKeyboardLockFrame
{
	CGFloat width = kGVCKeyboardHideLockSize.width;
	CGFloat height = kGVCKeyboardHideLockSize.height;
	CGFloat xOffset = self.view.window.bounds.size.width - width - 5.0f;
	CGFloat yOffset = self.view.window.bounds.size.height - height - 6.0f;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)hideKeyboardLock
{
	if (!_hideKeyboardLock) {
		_hideKeyboardLock = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_lock_small.png"]];
		_hideKeyboardLock.contentMode = UIViewContentModeScaleAspectFit;
		_hideKeyboardLock.backgroundColor = [UIColor whiteColor];
		_hideKeyboardLock.userInteractionEnabled = YES;
		_hideKeyboardLock.layer.cornerRadius = 4.0f;
		_hideKeyboardLock.layer.masksToBounds = YES;
	}
	
	return _hideKeyboardLock;
}

- (void)addKeyboardMask
{
	self.hideKeyboardLock.frame = [self hideKeyboardLockFrame];
	[[UIApplication sharedApplication] rp_addSubviewOnFrontWindow:self.hideKeyboardLock];
}

- (void)removeKeyboardMask
{
	[self.hideKeyboardLock removeFromSuperview];
}

#pragma mark - Notification

- (void)registerNotification
{
	[RPNotificationCenter registerObject:self
					 forNotificationName:UIKeyboardDidShowNotification
								 handler:@selector(handleKeyboardDidShowNotification:)
							   parameter:nil];
	[RPNotificationCenter registerObject:self
					 forNotificationName:UIKeyboardWillShowNotification
								 handler:@selector(handleKeyboardWillShowNotification:)
							   parameter:nil];
}

- (void)unRegisterNotification
{
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardDidShowNotification parameter:nil];
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardWillShowNotification parameter:nil];
}

- (void)handleKeyboardDidShowNotification:(NSNotification *)notification
{
	if (self.pageWillLoad == GooglePageGplusWidget) {
		[self addKeyboardMask];
	}
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification
{
	if (self.pageWillLoad == GooglePageGplusWidget) {
		self.googleTop.constant = -100.0f;
		self.submitTop.constant = 490.0f;
		[UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
			[self.view layoutIfNeeded];
		}];
		
	} if (self.pageDidLoad == GooglePageAccountLogin) {
		[self performSelector:@selector(adjustWebViewBounds:) withObject:notification afterDelay:0];
	}
}

- (void)adjustWebViewBounds:(NSNotification *)notification
{
	self.webView.scrollView.bounds = self.webView.bounds;
}

- (void)zoomContent
{
	[self.webView.scrollView zoomToRect:CGRectMake(0.0f, 0.0f, 0.0f, 880.0f) animated:YES];
	[self.webView.scrollView setContentOffset:CGPointMake(0.0f, -300.0f) animated:YES];
}

@end
