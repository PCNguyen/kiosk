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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)toggleLoadingView:(BOOL)isVisible {
    if (isVisible) {
		//--check if loading view not already visible
		if (self.loadingView.alpha == 0.0f) {
			[self.loadingView show];
		}
    } else {
        [self.loadingView hide];
    }
}

- (PQFCirclesInTriangle *)loadingView {
    if (!_loadingView) {
        _loadingView = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
		_loadingView.loaderColor = [UIColor rpk_defaultBlue];
		_loadingView.delay = 0.0f;
		_loadingView.duration = 1.2f;
		_loadingView.separation = 10.0f;
    }

    return _loadingView;
}

@end
