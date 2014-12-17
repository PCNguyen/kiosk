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

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.showPageTitles = NO;
	self.showUrlWhileLoading = NO;
	self.showActionButton = NO;
	
	self.webView.backgroundColor = [UIColor ul_colorWithR:12.0f G:79.0f B:120.0f A:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[super webViewDidFinishLoad:webView];
	
	NSString *zoomScript = [NSString stringWithFormat:@"window.parent.document.body.style.zoom = 1.5;"];
	[webView stringByEvaluatingJavaScriptFromString:zoomScript];
}

@end
