//
//  RPKReloadView.m
//  Kiosk
//
//  Created by PC Nguyen on 1/21/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKReloadView.h"

@interface RPKReloadView ()

@property (nonatomic, strong) UIImageView *reloadImageView;
@property (nonatomic, strong) UILabel *reloadLabel;

@end

@implementation RPKReloadView

- (void)commonInit
{
	[self addSubview:self.reloadImageView];
	[self addSubview:self.reloadLabel];
}

- (UIImageView *)reloadImageView
{
	if (!_reloadImageView) {
		_reloadImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@""]];
		_reloadImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _reloadImageView;
}

@end
