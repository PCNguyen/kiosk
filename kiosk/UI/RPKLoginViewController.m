//
//  RPKLoginViewController.m
//  Kiosk
//
//  Created by PC Nguyen on 1/19/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKLoginViewController.h"
#import "UITextField+RP.h"
#import "RPAuthenticationHandler.h"
#import "UIFont+RP.h"
#import "UIColor+RP.h"
#import "UIViewController+Alert.h"
#import "RPAccountManager.h"

#import <AppSDK/NSString+AL.h>

#define kRPLoginViewControllerTextFieldHeight				37.0f
#define kRPLoginViewControllerLoginButtonHeight				47.0f

@interface RPKLoginViewController () <UITextFieldDelegate>

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.userIDTextField.frame = [self userIDFrame];
    self.passwordTextField.frame = [self passwordFrame:self.userIDTextField.frame];
    self.loginButton.frame = [self loginButtonFrame:self.passwordTextField.frame];
}

#pragma mark - User ID

- (CGRect)userIDFrame
{
    CGFloat xOffset = self.paddings.left;
    CGFloat yOffset = self.paddings.top;
    CGFloat width = self.view.bounds.size.width - 2*xOffset;
    CGFloat height = kRPLoginViewControllerTextFieldHeight;

    CGRect frame = CGRectMake(xOffset, yOffset, width, height);
    return frame;
}

- (UITextField *)userIDTextField
{
    if (!_userIDTextField) {
        _userIDTextField = [UITextField rp_textFieldTemplate];
        _userIDTextField.attributedPlaceholder = [self placeHolderForText:@"Email Address"];
        _userIDTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userIDTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _userIDTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _userIDTextField.delegate = self;
        [_userIDTextField ul_addDismissAccessoryWithText:@"Done" barStyle:UIBarStyleDefault];
    }

    return _userIDTextField;
}

#pragma mark - Password

- (CGRect)passwordFrame:(CGRect)userIDFrame
{
    CGFloat xOffset = self.paddings.left;
    CGFloat yOffset = userIDFrame.origin.y + userIDFrame.size.height + self.spacings.height;
    CGFloat width = self.view.bounds.size.width - 2*xOffset;
    CGFloat height = kRPLoginViewControllerTextFieldHeight;

    CGRect frame = CGRectMake(xOffset, yOffset, width, height);
    return frame;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [UITextField rp_textFieldTemplate];
        _passwordTextField.attributedPlaceholder = [self placeHolderForText:@"Password"];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        [_passwordTextField ul_addDismissAccessoryWithText:@"Done" barStyle:UIBarStyleDefault];
    }

    return _passwordTextField;
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.userIDTextField isFirstResponder]) {
        [self.userIDTextField resignFirstResponder];
    } else {
        [self.passwordTextField resignFirstResponder];
    }

    return YES;
}

#pragma mark - Login Button

- (CGRect)loginButtonFrame:(CGRect)passwordFrame
{
    CGFloat xOffset = self.paddings.left;
    CGFloat yOffset = passwordFrame.origin.y + passwordFrame.size.height + self.spacings.height + 3.0f;
    CGFloat width = self.view.bounds.size.width - 2*xOffset;
    CGFloat height = kRPLoginViewControllerLoginButtonHeight;

    CGRect frame = CGRectMake(xOffset, yOffset, width, height);
    return frame;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor rp_brightBlue];
        _loginButton.titleLabel.font = [UIFont rp_fontWithSize:18.0f];
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(handleLoginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        _loginButton.layer.cornerRadius = 2.0f;
        _loginButton.layer.masksToBounds = YES;
    }

    return _loginButton;
}

- (void)handleLoginButtonTapped:(UIButton *)sender
{
    NSString *userName = self.userIDTextField.text;
    NSString *password = self.passwordTextField.text;

    if ([self validEmail:userName] && [self validPassword:password]) {

        if ([self.passwordTextField isFirstResponder]) {
            [self.passwordTextField resignFirstResponder];
        } else if ([self.userIDTextField isFirstResponder]) {
            [self.userIDTextField resignFirstResponder];
        }

        [RPAuthenticationHandler addObserverForNetworkActivityBegin:self
                                                           selector:@selector(handleAuthenticationBeginNotification:)];
        [RPAuthenticationHandler addObserverForNetworkActivityComplete:self
                                                              selector:@selector(handleAuthenticationCompleteNotification:)];
        [RPAuthenticationHandler loginWithUsername:userName password:password];
    }
}

#pragma mark - Notification

- (void)handleAuthenticationBeginNotification:(NSNotification *)notification
{

}

- (void)handleAuthenticationCompleteNotification:(NSNotification *)notification
{
    if ([[RPAccountManager sharedManager] isAuthenticated]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}


#pragma mark - Private

- (NSAttributedString *)placeHolderForText:(NSString *)text
{
    return [text al_attributedStringWithFont:[UIFont rp_boldFontWithSize:14.0f] textColor:[UIColor rp_mediumGrey]];
}

- (BOOL)validEmail:(NSString *)email
{
    BOOL valid = NO;

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    if (email.length > 0 && [emailTest evaluateWithObject:email]) {
        valid = YES;
    }

    if (!valid) {
        [self rp_showAlertViewWithTitle:@"Error" message:@"Please enter valid E-mail address" cancelTitle:@"OK"];
    }

    return valid;
}

- (BOOL)validPassword:(NSString *)password
{
    BOOL valid = password.length > 0;

    if (!valid) {
        [self rp_showAlertViewWithTitle:@"Error" message:@"Password cannot be empty" cancelTitle:@"OK"];
    }

    return valid;
}

@end
