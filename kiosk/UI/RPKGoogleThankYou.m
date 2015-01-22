//
//  RPKGoogleThankYou.m
//  Kiosk
//
//  Created by PC Nguyen on 1/22/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import "RPKGoogleThankYou.h"

#define kGTYLogoImageSize		CGSizeMake(100.0f, 100.0f)

@interface RPKGoogleThankYou ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *messageTitle;
@property (nonatomic, strong) UILabel *messageSubtitle;

@end

@implementation RPKGoogleThankYou

- (void)commonInit
{
	self.backgroundColor = [UIColor rpk_backgroundColor];
	self.spacings = CGSizeMake(0.0f, 20.0f);
	
	[self addSubview:self.logoImageView];
	[self addConstraints:[self.logoImageView ul_pinWithInset:UIEdgeInsetsMake(100.0f, kUIViewUnpinInset, kUIViewUnpinInset, kUIViewUnpinInset)]];
	[self addConstraint:[self.logoImageView ul_centerAlignWithView:self direction:@"V"]];
	
	[self addSubview:self.messageTitle];
	[self addConstraints:[self.messageTitle ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.logoImageView distance:self.spacings.height topToBottom:NO]];

	[self addSubview:self.messageSubtitle];
	[self addConstraints:[self.messageSubtitle ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.messageTitle distance:self.spacings.height topToBottom:NO]];
	[self addConstraints:[self.messageSubtitle ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 100.0f, kUIViewUnpinInset, 100.0f)]];
}

#pragma mark - UI Element

- (UIImageView *)logoImageView
{
	if (!_logoImageView) {
		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_gplus.png"]];
		_logoImageView.contentMode = UIViewContentModeScaleAspectFit;
		[_logoImageView ul_enableAutoLayout];
		[_logoImageView ul_fixedSize:kGTYLogoImageSize];
	}
	
	return _logoImageView;
}

- (UILabel *)messageTitle
{
	if (!_messageTitle) {
		_messageTitle = [[UILabel alloc] init];
		_messageTitle.textAlignment = NSTextAlignmentCenter;
		_messageTitle.text = NSLocalizedString(@"Thank you!", nil);
		_messageTitle.font = [UIFont rpk_fontWithSize:80.0f];
		_messageTitle.textColor = [UIColor rpk_darkGray];
		[_messageTitle ul_enableAutoLayout];
	}
	
	return _messageTitle;
}

- (UILabel *)messageSubtitle
{
	if (!_messageSubtitle) {
		_messageSubtitle = [[UILabel alloc] init];
		_messageSubtitle.textAlignment = NSTextAlignmentCenter;
		_messageSubtitle.text = NSLocalizedString(@"Your review has been submitted and you are now being logged out...", nil);
		_messageSubtitle.font = [UIFont rpk_fontWithSize:30.0f];
		_messageSubtitle.textColor = [UIColor rpk_darkGray];
		_messageSubtitle.numberOfLines = 0;
		[_messageSubtitle ul_enableAutoLayout];
	}
	
	return _messageSubtitle;
}

@end
