//
//  RPAlertController.m
//  Reputation
//
//  Created by PC Nguyen on 10/29/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPAlertController.h"
#import "UILabel+DynamicHeight.h"
#import "UIButton+RP.h"
#import "UITextField+RP.h"
#import "UIFont+RPK.h"
#import "UIColor+RPK.h"

#import "NSAttributedString+RP.h"

#import <AppSDK/AppLibExtension.h>
#import <AppSDK/UILibExtension.h>

#pragma mark -
#define kABButtonCornerRadius				2.0f
#define kABButtonBorderWidth				0.5f

/**********************************
 *  RPAlertButton
 **********************************/
@interface RPAlertButton ()

@property (nonatomic, strong) UIButton *actionButton;
@property (readwrite, copy) RPAlertButtonAction actionBlock;

@end

@implementation RPAlertButton

- (instancetype)initWithTitle:(NSString *)title
						style:(RPAlertButtonStyle)style
					   action:(RPAlertButtonAction)actionHandler
{
	if (self = [super init]) {
		_actionButton = [self buttonWithStyle:style title:title];
		_actionBlock = actionHandler;
	}
	
	return self;
}

- (UIButton *)buttonWithStyle:(RPAlertButtonStyle)style title:(NSString *)title
{
	UIButton *styledButton = nil;
	
	switch (style) {
		case AlertButtonStyleCancel:
			styledButton = [self cancelButton:title];
			break;
		case AlertButtonStyleDestructive:
			styledButton = [self destructiveButton:title];
			break;
		case AlertButtonStyleDefault:
		default:
			styledButton = [self defaultButton:title];
			break;
	}
	
	styledButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	styledButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[styledButton addTarget:self action:@selector(handleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	
	return styledButton;
}

- (void)handleButtonTapped:(id)sender
{
	__weak RPAlertButton *selfPointer = self;
	
	if (self.actionBlock) {
		self.actionBlock(selfPointer);
	}
}

#pragma mark Style Factory

- (UIButton *)defaultButton:(NSString *)title
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f] textColor:[UIColor whiteColor]];
	NSAttributedString *attributedSelectedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f] textColor:[UIColor ul_colorWithR:255 G:255 B:255 A:0.5f]];
	[customButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[customButton setAttributedTitle:attributedSelectedTitle forState:UIControlStateHighlighted];
	[customButton setBackgroundColor:[UIColor rpk_brightBlue]];
	
	customButton.layer.cornerRadius = kABButtonCornerRadius;
	customButton.layer.masksToBounds = YES;
	return customButton;
}

- (UIButton *)cancelButton:(NSString *)title
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f]
																   textColor:[UIColor rpk_mediumGray]];
	NSAttributedString *attributedSelectedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f]
																		   textColor:[[UIColor rpk_mediumGray] colorWithAlphaComponent:0.5f]];
	[customButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[customButton setAttributedTitle:attributedSelectedTitle forState:UIControlStateHighlighted];
	[customButton setBackgroundColor:[UIColor whiteColor]];
	
	customButton.layer.cornerRadius = kABButtonCornerRadius;
	customButton.layer.borderColor = [[UIColor rpk_borderColor] CGColor];
	customButton.layer.borderWidth = kABButtonBorderWidth;
	customButton.layer.masksToBounds = YES;
	return customButton;
}

- (UIButton *)destructiveButton:(NSString *)title
{
	UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
	NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f]
																   textColor:[UIColor redColor]];
	NSAttributedString *attributedSelectedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f]
																		   textColor:[[UIColor rpk_mediumGray] colorWithAlphaComponent:0.5f]];
	[customButton setAttributedTitle:attributedTitle forState:UIControlStateNormal];
	[customButton setAttributedTitle:attributedSelectedTitle forState:UIControlStateHighlighted];
	[customButton setBackgroundColor:[UIColor whiteColor]];
	
	customButton.layer.cornerRadius = kABButtonCornerRadius;
	customButton.layer.borderColor = [[UIColor rpk_borderColor] CGColor];
	customButton.layer.borderWidth = kABButtonBorderWidth;
	customButton.layer.masksToBounds = YES;
	return customButton;
}

@end

#pragma mark -
#define kACVTextFieldHeight					35.0f
#define kACVButtonHeight					40.0f
#define kACVSpacings						CGSizeMake(5.0f, 5.0f)
#define kACVPaddings						UIEdgeInsetsMake(10.0f, 5.0f, 5.0f, 5.0f)

/**********************************
 * RPAlertContentView
 **********************************/
@interface RPAlertContentView : UIView <RPDynamicHeight>

@property (nonatomic, strong) UIView<RPDynamicHeight> *titleView;
@property (nonatomic, strong) UIView<RPDynamicHeight> *messageView;
@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSMutableArray *alertButtons;

@end

@implementation RPAlertContentView

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	//--adding the views
	if (self.titleView) {
		[self ul_addSubviewIfNotExist:self.titleView];
	}
	if (self.messageView) {
		[self ul_addSubviewIfNotExist:self.messageView];
	}
	
	for (RPAlertButton *alertButton in self.alertButtons) {
		[self ul_addSubviewIfNotExist:alertButton.actionButton];
	}
	
	for (UITextField *textField in self.textFields) {
		[self ul_addSubviewIfNotExist:textField];
	}
	
	//--layout frame
	CGRect firstButtonFrame = self.bounds;
	firstButtonFrame.origin.y = self.bounds.size.height;
	firstButtonFrame.size.height = 0.0f;
	
	if ([self.alertButtons count] == 2) {
		firstButtonFrame = [self layoutButtonHorizontal:firstButtonFrame];
	} else {
		firstButtonFrame = [self layoutButtonVertical:firstButtonFrame];
	}
	
	CGRect firstTextFieldFrame = [self layoutTextFieldVertical:firstButtonFrame];
	if (self.messageView) {
		self.titleView.frame = [self titleViewFrame:CGRectZero];
	} else {
		self.titleView.frame = [self titleViewFrame:firstTextFieldFrame];
	}
	
	if (self.titleView) {
		self.messageView.frame = [self messageViewFrame:firstTextFieldFrame topFrame:self.titleView.frame];
	} else {
		self.messageView.frame = [self messageViewFrame:firstTextFieldFrame topFrame:CGRectZero];
	}
}

- (CGRect)layoutTextFieldVertical:(CGRect)preferenceFrame
{
	__block CGRect finalFrame = preferenceFrame;
	
	[self.textFields enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITextField *textField, NSUInteger index, BOOL *stop) {
		finalFrame = [self verticalTextFieldFrame:preferenceFrame atIndex:index];
		textField.frame = finalFrame;
	}];
	
	return finalFrame;
}

- (CGRect)layoutButtonHorizontal:(CGRect)preferenceFrame
{
	__block CGRect finalFrame = preferenceFrame;
	
	[self.alertButtons enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RPAlertButton *alertButton, NSUInteger index, BOOL *stop) {
		finalFrame = [self horizontalButtonFrameAtIndex:index];
		alertButton.actionButton.frame = finalFrame;
	}];

	return finalFrame;
}

- (CGRect)layoutButtonVertical:(CGRect)preferenceFrame
{
	__block CGRect finalFrame = preferenceFrame;
	[self.alertButtons enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(RPAlertButton *alertButton, NSUInteger index, BOOL *stop) {
		finalFrame = [self verticalButtonFrameAtIndex:index];
		alertButton.actionButton.frame = finalFrame;
	}];
	
	return finalFrame;
}

#pragma mark TitleView

- (CGRect)titleViewFrame:(CGRect)preferenceFrame
{
	CGFloat xOffset = kACVPaddings.left;
	CGFloat yOffset = kACVPaddings.top;
	CGFloat width = self.bounds.size.width - kACVPaddings.left - kACVPaddings.right;
	CGFloat height = 0.0f;
	if (self.titleView) {
		height = [self.titleView minHeightForWidth:width];
	}
	
	if (!self.messageView) {
		yOffset = (preferenceFrame.origin.y - height) / 2;
	}
	
	return CGRectMake(xOffset, yOffset, width, height);
}

#pragma mark MessageView

- (CGRect)messageViewFrame:(CGRect)preferenceFrame topFrame:(CGRect)topFrame
{
	CGFloat xOffset = kACVPaddings.left;
	CGFloat width = self.bounds.size.width - kACVPaddings.left - kACVPaddings.right;
	CGFloat height = 0.0f;
	
	if (self.messageView) {
		height = [self.messageView minHeightForWidth:width];
	}
	
	CGFloat yOffset = (preferenceFrame.origin.y - topFrame.origin.y - topFrame.size.height - height) / 2;
	yOffset += (topFrame.origin.y + topFrame.size.height);
	
	if (!self.titleView) {
		yOffset = (preferenceFrame.origin.y - height) / 2;
	}
	
	return CGRectMake(xOffset, yOffset, width, height);
}

#pragma mark TextField

- (CGRect)verticalTextFieldFrame:(CGRect)preferenceFrame atIndex:(NSInteger)index
{
	CGFloat width = self.bounds.size.width - kACVPaddings.left - kACVPaddings.right;
	CGFloat xOffset = (self.bounds.size.width - width) / 2;
	CGFloat height = 0.0f;
	
	if ([self.textFields count] > 0) {
		height = kACVTextFieldHeight;
	}
	
	CGFloat invertIndex = self.textFields.count - index;
	CGFloat yOffset = preferenceFrame.origin.y - invertIndex * (kACVTextFieldHeight + kACVSpacings.height);
	
	if ([self.alertButtons count] == 0) {
		yOffset += kACVSpacings.height;
		yOffset -= kACVPaddings.bottom;
	}
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (NSMutableArray *)textFields
{
	if (!_textFields) {
		_textFields = [NSMutableArray array];
	}
	
	return _textFields;
}

- (void)addtextField:(UITextField *)textField
{
	[self.textFields al_addObject:textField];
}

#pragma mark Buttons

- (CGRect)horizontalButtonFrameAtIndex:(NSInteger)index
{
	CGFloat allButtonWidth = self.bounds.size.width - kACVPaddings.left - kACVPaddings.right - (kACVSpacings.width * (self.alertButtons.count - 1));
	CGFloat width = 0;
	CGFloat xOffset = 0;
	CGFloat height = 0;
	
	if (self.alertButtons.count > 0) {
		width = allButtonWidth / self.alertButtons.count;
		xOffset = kACVPaddings.left + index * width + index * kACVSpacings.width;
		height = kACVButtonHeight;
	}
	
	CGFloat yOffset = self.bounds.size.height - height - kACVPaddings.bottom;
	return CGRectMake(xOffset, yOffset, width, height);
}

- (CGRect)verticalButtonFrameAtIndex:(NSInteger)index
{
	CGFloat width = self.bounds.size.width * 0.5f;
	CGFloat xOffset = (self.bounds.size.width - width) / 2;
	CGFloat height = 0.0f;
	CGFloat yOffset = self.bounds.size.height - kACVPaddings.bottom;
	
	if ([self.alertButtons count] > 0) {
		height = kACVButtonHeight;
		CGFloat invertIndex = self.alertButtons.count - index;
		yOffset -= invertIndex * (kACVButtonHeight + kACVSpacings.height);
		yOffset += kACVSpacings.height;
	}
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (NSMutableArray *)alertButtons
{
	if (!_alertButtons) {
		_alertButtons = [NSMutableArray array];
	}
	
	return _alertButtons;
}

- (void)addAlertButton:(RPAlertButton *)alertButton
{
	[self.alertButtons al_addObject:alertButton];
}

#pragma mark RPDynamicHeight Protocol

- (CGFloat)minHeightForWidth:(CGFloat)width
{
	CGFloat adjustWidth = width - kACVPaddings.left - kACVPaddings.right;
	CGFloat titleHeight = [self.titleView minHeightForWidth:adjustWidth];
	if (titleHeight > 0) {
		titleHeight += kACVSpacings.height;
	}
	
	CGFloat messageHeight = [self.messageView minHeightForWidth:adjustWidth];
	if (messageHeight > 0) {
		messageHeight += (kACVSpacings.height + kACVPaddings.bottom);
	}
	
	CGFloat textFieldHeight = [self.textFields count] * (kACVTextFieldHeight + kACVSpacings.height);
	
	CGFloat buttonHeight = [self.alertButtons count] * (kACVButtonHeight + kACVSpacings.height);
	if ([self.alertButtons count] == 2) {
		buttonHeight = kACVButtonHeight;
	} else if ([self.alertButtons count] > 0) {
		buttonHeight -= kACVSpacings.height; //--take out the spacing at the bottom
	}
	
	return (kACVPaddings.top + titleHeight + messageHeight + textFieldHeight + buttonHeight + kACVPaddings.bottom);
}

@end

#pragma mark -
#define kACMaxAlertRatio					CGSizeMake(0.4, 0.8)
#define kACMinAlertHeight					180.0f
#define kACTransitionDuration				0.25f

/*********************************
 *  RPAlertController
 *********************************/
@interface RPAlertController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) RPAlertContentView *alertView;

@end

@implementation RPAlertController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
	if (self = [super init]) {
		[self commonInit];
		
		self.alertView.titleView = [self titleLabelForText:title];
		self.alertView.messageView = [self messageLabelForText:message];
	}
	
	return self;
}

- (instancetype)initWithTitleView:(UIView<RPDynamicHeight> *)titleView messageView:(UIView<RPDynamicHeight> *)messageView
{
	if (self = [super init]) {
		[self commonInit];
		
		self.alertView.titleView = titleView;
		self.alertView.messageView = messageView;
	}
	
	return self;
}

- (void)commonInit
{
	self.modalPresentationStyle = UIModalPresentationCustom;
	self.transitioningDelegate = self;
	[self.view ul_addTapGestureWithTarget:self action:@selector(handleTapGesture:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor ul_colorWithR:162 G:172 B:182 A:0.4f];
	[self.view addSubview:self.alertView];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.alertView.frame = [self alertViewFrame];
}

#pragma mark Alert View

- (CGRect)alertViewFrame
{
	CGSize viewSize = self.view.bounds.size;
	CGFloat width = viewSize.width * kACMaxAlertRatio.width;
	CGFloat height = [self.alertView minHeightForWidth:width];
	CGFloat maxAllowHeight = viewSize.height * kACMaxAlertRatio.height;
	if (height > maxAllowHeight) {
		height = maxAllowHeight;
	}
	
	if (height < kACMinAlertHeight) {
		height = kACMinAlertHeight;
	}
	
	CGFloat xOffset = (viewSize.width - width) / 2; //--center align
	CGFloat yOffset = (viewSize.height - height) / 2;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (RPAlertContentView *)alertView
{
	if (!_alertView) {
		_alertView = [[RPAlertContentView alloc] initWithFrame:CGRectZero];
		_alertView.backgroundColor = [UIColor whiteColor];
		_alertView.layer.cornerRadius = 5.0f;
		_alertView.layer.masksToBounds = YES;
	}
	
	return _alertView;
}

#pragma mark Button

- (void)addButtonTitle:(NSString *)title style:(RPAlertButtonStyle)style action:(RPAlertButtonAction)actionHandler
{
	__weak RPAlertController *selfPointer = self;
	RPAlertButtonAction alertAction = ^(RPAlertButton *alertButton) {
		[selfPointer dismissAlertCompletion:^{
			if (actionHandler) {
				actionHandler(alertButton);
			}
		}];
	};
	
	RPAlertButton *alertButton = [[RPAlertButton alloc] initWithTitle:title style:style action:alertAction];
	[self.alertView addAlertButton:alertButton];
}

- (void)addTextFieldWithStyleHandler:(RPAlertTextFieldStyleHandler)styleHandler
{
	UITextField *alertTextField = [UITextField rp_textFieldTemplate];
	alertTextField.layer.borderWidth = kABButtonBorderWidth;
	alertTextField.layer.cornerRadius = kABButtonCornerRadius;

	if (styleHandler) {
		styleHandler(alertTextField);
	}
	[self.alertView addtextField:alertTextField];
}

- (NSArray *)textFields
{
	return [self.alertView textFields];
}

#pragma mark Transition

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
	return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
	return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
	return kACTransitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
	UIView *containerView = [transitionContext containerView];
	UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
	UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
	
	if (toViewController.isBeingPresented) {
		[fromViewController.view ul_blur];
		[containerView addSubview:toViewController.view];
		toViewController.view.alpha = 0.0f;
		self.alertView.alpha = 0.5f;
		self.alertView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
		
		[self animate:^{
			toViewController.view.alpha = 1.0f;
			self.alertView.transform = CGAffineTransformIdentity;
			self.alertView.alpha = 1.0f;
		} completion:^(BOOL finished) {
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
		
	} else {
		[toViewController.view ul_clearBlur];
		[self animate:^{
			fromViewController.view.alpha = 0.0f;
		} completion:^(BOOL finished) {
			[fromViewController.view removeFromSuperview];
			[transitionContext completeTransition:![transitionContext transitionWasCancelled]];
		}];
	}
}

- (void)animate:(void (^)())animationBlock completion:(void (^)(BOOL finished))completionBlock
{
	[UIView animateWithDuration:kACTransitionDuration delay:0
		 usingSpringWithDamping:500 initialSpringVelocity:15
						options:0 animations:animationBlock
					 completion:completionBlock];

}

#pragma mark Label Formatting

- (UILabel *)titleLabelForText:(NSString *)title
{
	UILabel *label = nil;
	
	if ([title length] > 0) {
		NSAttributedString *attributedTitle = [title al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:20.0f] textColor:nil];
		[attributedTitle rp_addLineSpacing:3.0f];
		
		label = [[UILabel alloc] init];
		label.attributedText = attributedTitle;
		label.textAlignment = NSTextAlignmentCenter;
	}
	
	return label;
}

- (UILabel *)messageLabelForText:(NSString *)message
{
	UILabel *label = nil;
	
	if ([message length] > 0) {
		NSAttributedString *attributedMessage = [message al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:18.0f] textColor:[UIColor rpk_lightGray]];
		[attributedMessage rp_addLineSpacing:3.0f];
		
		label = [[UILabel alloc] init];
		label.attributedText = attributedMessage;
		label.textAlignment = NSTextAlignmentCenter;
		label.numberOfLines = 0;
	}
	
	return label;
}

#pragma mark Private

- (void)handleTapGesture:(UIGestureRecognizer *)gesture
{
	[self dismissAlertCompletion:NULL];
}

- (void)dismissAlertCompletion:(void (^)())completion
{
	[self dismissViewControllerAnimated:YES completion:completion];
}

@end