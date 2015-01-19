//
//  RPKViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKViewController.h"

@interface RPKViewController ()

@property (nonatomic, strong) PQFBarsInCircle *loadingView;

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

- (PQFBarsInCircle *)loadingView {
    if (!_loadingView) {
        _loadingView = [[PQFBarsInCircle alloc] initLoaderOnView:self.view];
    }

    return _loadingView;
}
@end
