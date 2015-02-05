//
//  RPKNavigationController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKNavigationController.h"
#import "RPKUIKit.h"

@interface RPKNavigationController ()

@end

@implementation RPKNavigationController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self adjustFlatUI];
}

#pragma mark - UI Helpers

- (void)adjustFlatUI
{
	[[self class] customThemeForBar:self.navigationBar];
	
	//--set bar button item color
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
							  NSFontAttributeName:[UIFont rpk_fontWithSize:20.0f]}
	 forState:UIControlStateNormal];
	
	[[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
	 setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],
							  NSFontAttributeName:[UIFont rpk_fontWithSize:20.0f]}
	 forState:UIControlStateDisabled];
}

+ (void)customThemeForBar:(UINavigationBar *)navigationBar
{
	UIColor *navigationBarColor = [UIColor ul_colorWithR:20.0f G:122.0f B:164.0f A:1.0f];
	
	[navigationBar setBackgroundColor:navigationBarColor];
	[navigationBar setShadowImage:[[UIImage alloc] init]];
	[navigationBar setBarTintColor:navigationBarColor];
	navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor],
										  NSFontAttributeName: [UIFont rpk_fontWithSize:24.0f]};
	
}
@end
