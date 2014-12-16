//
//  RPKKioskViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKKioskViewController.h"

@interface RPKKioskViewController ()

@end

@implementation RPKKioskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.showPageTitles = NO;
	self.showUrlWhileLoading = NO;
	self.showActionButton = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[super webViewDidFinishLoad:webView];
}

@end
