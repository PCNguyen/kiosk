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
        [self.loadingView show];
    } else {
        [self.loadingView hide];
    }
}

- (PQFCirclesInTriangle *)loadingView {
    if (!_loadingView) {
        _loadingView = [[PQFCirclesInTriangle alloc] initLoaderOnView:self.view];
        _loadingView.maxDiam = 150.0f;
		_loadingView.loaderColor = [UIColor rpk_defaultBlue];
    }

    return _loadingView;
}

@end
