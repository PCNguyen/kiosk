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
#import "UIViewController+Alert.h"
#import "RPAccountManager.h"

#import <AppSDK/NSString+AL.h>

@interface RPKLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *divider;
@property (nonatomic, strong) UILabel *kioskLabel;
@property (nonatomic, strong) UITextField *userIDTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *termConditionLabel;

@end

@implementation RPKLoginViewController

- (void)loadView
{
    [super loadView];

    self.paddings = UIEdgeInsetsMake(100.0f, 150.0f, 0.0f, 150.0f);
    self.spacings = CGSizeMake(0.0f, 15.0f);

    self.view.backgroundColor = [UIColor rpk_backgroundColor];

	//--add views
	[self.view addSubview:self.logoImageView];
	[self.view addSubview:self.divider];
	[self.view addSubview:self.kioskLabel];
    [self.view addSubview:self.userIDTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
	[self.view addSubview:self.termConditionLabel];
	
	//--layout views
	[self.view addConstraints:[self.logoImageView ul_pinWithInset:UIEdgeInsetsMake(120.0f, kUIViewUnpinInset, kUIViewUnpinInset, kUIViewUnpinInset)]];
	[self.view addConstraint:[self.logoImageView ul_centerAlignWithView:self.view direction:@"V"]];
	
	[self.view addConstraints:[self.divider ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, kUIViewUnpinInset, self.paddings.right)]];
	[self.view addConstraints:[self.divider ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.logoImageView distance:(2 *self.spacings.height) topToBottom:NO]];
	
	[self.view addConstraints:[self.kioskLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.divider distance:(2 * self.spacings.height) topToBottom:NO]];
	
	[self.view addConstraints:[self.userIDTextField ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, kUIViewUnpinInset, self.paddings.right)]];
	[self.view addConstraints:[self.userIDTextField ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.kioskLabel distance:(3 * self.spacings.height) topToBottom:NO]];
	
	[self.view addConstraints:[self.passwordTextField ul_matchSizeOfView:self.userIDTextField ratio:CGSizeMake(1.0f, 1.0f)]];
	[self.view addConstraints:[self.passwordTextField ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.userIDTextField distance:self.spacings.height topToBottom:NO]];
	
	[self.view addConstraints:[self.loginButton ul_matchSizeOfView:self.userIDTextField ratio:CGSizeMake(1.0f, 1.2f)]];
	[self.view addConstraints:[self.loginButton ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.passwordTextField distance:self.spacings.height topToBottom:NO]];
	
	[self.view addConstraints:[self.termConditionLabel ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, kUIViewUnpinInset, self.paddings.right)]];
	[self.view addConstraints:[self.termConditionLabel ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.loginButton distance:self.spacings.height topToBottom:NO]];
}

#pragma mark - Static UI

- (UIImageView *)logoImageView
{
	if (!_logoImageView) {
		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"logo_reputation.png"]];
		_logoImageView.contentMode = UIViewContentModeScaleAspectFit;
		[_logoImageView ul_enableAutoLayout];
		[_logoImageView ul_tightenContentWithPriority:UILayoutPriorityDefaultHigh];
	}
	
	return _logoImageView;
}

- (UIView *)divider
{
	if (!_divider) {
		_divider = [[UIView alloc] init];
		_divider.backgroundColor = [UIColor rpk_borderColor];
		[_divider ul_enableAutoLayout];
		[_divider ul_fixedSize:CGSizeMake(0.0f, 0.5f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _divider;
}

- (UILabel *)kioskLabel
{
	if (!_kioskLabel) {
		_kioskLabel = [[UILabel alloc] init];
		_kioskLabel.backgroundColor = [UIColor clearColor];
		_kioskLabel.textAlignment = NSTextAlignmentCenter;
		_kioskLabel.text = NSLocalizedString(@"Kiosk Login", nil);
		_kioskLabel.font = [UIFont rpk_boldFontWithSize:50.0f];
		_kioskLabel.textColor = [UIColor rpk_defaultBlue];
		[_kioskLabel ul_enableAutoLayout];
		[_kioskLabel ul_tightenContentWithPriority:UILayoutPriorityDefaultHigh];
	}
	
	return _kioskLabel;
}

- (UILabel *)termConditionLabel
{
	if (!_termConditionLabel) {
		_termConditionLabel = [[UILabel alloc] init];
		_termConditionLabel.backgroundColor = [UIColor clearColor];
		_termConditionLabel.textAlignment = NSTextAlignmentLeft;
		_termConditionLabel.text = NSLocalizedString(@"Term and Conditions", nil);
		_termConditionLabel.font = [UIFont rpk_boldFontWithSize:16.0f];
		_termConditionLabel.textColor = [UIColor rpk_lightGray];
		[_termConditionLabel ul_enableAutoLayout];
	}
	
	return _termConditionLabel;
}

#pragma mark - Text Fields

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
		[_userIDTextField ul_enableAutoLayout];
		[_userIDTextField ul_fixedSize:CGSizeMake(0.0f, 60.0f) priority:UILayoutPriorityDefaultHigh];
    }

    return _userIDTextField;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [UITextField rp_textFieldTemplate];
        _passwordTextField.attributedPlaceholder = [self placeHolderForText:@"Password"];
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.delegate = self;
        [_passwordTextField ul_addDismissAccessoryWithText:@"Done" barStyle:UIBarStyleDefault];
		[_passwordTextField ul_enableAutoLayout];
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

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor rpk_brightBlue];
        _loginButton.titleLabel.font = [UIFont rpk_fontWithSize:25.0f];
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(handleLoginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

        _loginButton.layer.cornerRadius = 2.0f;
        _loginButton.layer.masksToBounds = YES;
		[_loginButton ul_enableAutoLayout];
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
    [self toggleLoadingView:YES];
}

- (void)handleAuthenticationCompleteNotification:(NSNotification *)notification
{
    [self toggleLoadingView:NO];

    if ([[RPAccountManager sharedManager] isAuthenticated]) {
        [self dismissViewControllerAnimated:YES completion:^{
			if ([self.delegate respondsToSelector:@selector(loginViewControllerDidDismissed)]) {
				[self.delegate loginViewControllerDidDismissed];
			}
		}];
    }
}

#pragma mark - Private

- (NSAttributedString *)placeHolderForText:(NSString *)text
{
    return [text al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f] textColor:[UIColor rpk_mediumGray]];
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
