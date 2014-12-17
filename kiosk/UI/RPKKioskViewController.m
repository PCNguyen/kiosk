//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKKioskViewController.h"
#import "RPKUIKit.h"

@interface RPKKioskViewController ()

@end

@implementation RPKKioskViewController

+ (void)initialize {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	[dictionary setObject:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.75.14 (KHTML, like Gecko) Version/7.0.3 Safari/7046A194A"
				   forKey:@"UserAgent"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.showPageTitles = NO;
	self.showUrlWhileLoading = NO;
	self.showActionButton = NO;
	
	self.webView.backgroundColor = [UIColor ul_colorWithR:12.0f G:79.0f B:120.0f A:1.0f];
	self.webView.scalesPageToFit = YES;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[super webViewDidFinishLoad:webView];
	
	if (!webView.isLoading) {
		NSLog(@"%@",webView.request);
		__weak RPKKioskViewController *selfPointer = self;
		[self performSelector:@selector(centerZoom) withObject:selfPointer afterDelay:5.0f];

	}
}

- (void)centerZoom
{
	CGSize dialogSize = CGSizeMake(560.0f, 420.0f);
	CGSize scrollViewSize = self.view.bounds.size;
	CGFloat xOffset = (scrollViewSize.width - dialogSize.width) / 2;
	CGFloat yOffset = (scrollViewSize.height - dialogSize.height) / 2;

	CGRect zoomRect = CGRectMake(xOffset, yOffset, dialogSize.width, dialogSize.height);
	[self.webView.scrollView zoomToRect:zoomRect animated:YES];

}

@end
