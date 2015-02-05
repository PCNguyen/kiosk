//
//  RPKViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKViewController.h"

@interface RPKViewController ()

@property (nonatomic, strong) PQFCirclesInTriangle *loadingView;

@end

@implementation RPKViewController

- (void)loadView
{
	[super loadView];
	
	[self ul_adjustIOS7Boundaries];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self tintNavigationItems];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleAdministratorGesture:)];
	tapGesture.numberOfTapsRequired = 1;
	tapGesture.numberOfTouchesRequired = 3;
	[self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[self.loadingView hide];
	[self.loadingView remove];
	self.loadingView = nil;
}

- (void)handleAdministratorGesture:(UIGestureRecognizer *)gesture
{
	if ([self.administratorDelegate respondsToSelector:@selector(handleAdministratorTask)]) {
		[self.administratorDelegate handleAdministratorTask];
	}
}

- (void)toggleLoadingView:(BOOL)isVisible {
    if (isVisible) {
        [self.loadingView show];
    } else {
        [self.loadingView hide];
    }
}

- (PQFCirclesInTriangle *)loadingView {
    if (!_loadingView) {
        _loadingView = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view.window];
		_loadingView.loaderColor = [UIColor rpk_defaultBlue];
		_loadingView.delay = 0.0f;
		_loadingView.duration = 1.2f;
		_loadingView.separation = 10.0f;
    }

    return _loadingView;
}

#pragma mark - Tinting

- (void)tintNavigationItems
{
	[self tintNavigationItemsWithColor:[UIColor whiteColor]];
}

- (void)tintNavigationItemsWithColor:(UIColor *)color
{
	//--set color for custom button
	self.navigationItem.leftBarButtonItem.tintColor = color;
	self.navigationItem.rightBarButtonItem.tintColor = color;
	
	//--set color for system button
	self.navigationController.navigationBar.tintColor = color;
}

@end
