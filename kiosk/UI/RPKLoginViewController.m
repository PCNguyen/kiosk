//
//  RPKLoginViewController.m
//  Kiosk
//
//  Created by PC Nguyen on 1/19/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKLoginViewController.h"

@interface RPKLoginViewController ()

@property (nonatomic, strong) UITextField *userIDTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation RPKLoginViewController

- (void)loadView
{
    [super loadView];

    [self.view addSubview:self.userIDTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
}

@end
