//
//  RPKMenuViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <AppSDK/AppLibExtension.h>

#import "RPKMenuViewController.h"
#import "RPKCollectionViewCell.h"
#import "RPKGoogleViewController.h"
#import "RPKKioskViewController.h"
#import "RPKSecuredView.h"
#import "RPKNavigationController.h"
#import "RPService.h"
#import "RPAlertController.h"
#import "RPLocationSelectionViewController.h"
#import "RPKLoginViewController.h"

#import "RPNotificationCenter.h"
#import "RPAuthenticationHandler.h"

#import "RPKLayoutManager.h"
#import "NSAttributedString+RP.h"
#import "RPAccountManager.h"
#import "RPReferenceHandler.h"

#import "UIApplication+RP.h"

#define kMCLogoImageSize			CGSizeMake(150.0f, 150.0f)

#pragma mark -

/********************************
 *  RPKMenuCell
 ********************************/
@interface RPKMenuCell : RPKCollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *lockImageView;
@property (nonatomic, strong) UIImageView *buttonBackgroundView;
@property (nonatomic, strong) UILabel *sourceLabel;

/**
 *  Whether or not to display the secured lock next to icon
 *
 *  @param isSecured if YES then the lock is visible
 */
- (void)setSecuredItem:(BOOL)isSecured;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(25.0f, 10.0f, 25.0f, 0.0f);
	self.spacings = CGSizeMake(20.0f, 0.0f);
	
	[self.contentView addSubview:self.buttonBackgroundView];
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.lockImageView];
	[self.contentView addSubview:self.sourceLabel];
	
	[self.contentView addConstraints:[self.buttonBackgroundView ul_pinWithInset:UIEdgeInsetsZero]];
	[self.contentView addConstraints:[self.sourceLabel ul_horizontalAlign:NSLayoutFormatAlignAllCenterY withView:self.logoImageView distance:self.spacings.width leftToRight:NO]];
	
	//--allow room for arrow indicator
	[self.contentView addConstraints:[self.sourceLabel ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, kUIViewUnpinInset, kUIViewUnpinInset, 80.0f)]];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.logoImageView.frame = [self logoImageViewFrame];
	self.lockImageView.frame = [self lockImageViewFrame:self.logoImageView.frame];
}

#pragma mark - Override

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
	self.sourceLabel.text = menuItem.itemTitle;
	[self setSecuredItem:menuItem.isSecured];
}

#pragma mark - UI Elements

- (UIImageView *)buttonBackgroundView
{
	if (!_buttonBackgroundView) {
		_buttonBackgroundView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"bg_source_button.png"]];
		_buttonBackgroundView.contentMode = UIViewContentModeScaleAspectFit;
		[_buttonBackgroundView ul_enableAutoLayout];
	}
	
	return _buttonBackgroundView;
}

- (CGRect)logoImageViewFrame
{
	CGFloat xOffset = self.paddings.left;
	CGFloat yOffset = self.paddings.top;
	CGFloat height = self.contentView.bounds.size.height - yOffset - self.paddings.bottom;
	CGFloat width = height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)logoImageView
{
	if (!_logoImageView) {
		_logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_logoImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _logoImageView;
}

- (CGRect)lockImageViewFrame:(CGRect)logoImageViewFrame
{
	CGFloat width = logoImageViewFrame.size.width / 4;
	CGFloat height = logoImageViewFrame.size.height / 4;
	CGFloat xOffset = logoImageViewFrame.origin.x + logoImageViewFrame.size.width - width;
	CGFloat yOffset = logoImageViewFrame.origin.y + logoImageViewFrame.size.height - height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)lockImageView
{
	if (!_lockImageView) {
		_lockImageView = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_lock_small.png"]];
		_lockImageView.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _lockImageView;
}

- (void)setSecuredItem:(BOOL)isSecured
{
	self.lockImageView.alpha = isSecured;
}

- (UILabel *)sourceLabel
{
	if (!_sourceLabel) {
		_sourceLabel = [[UILabel alloc] init];
		_sourceLabel.font = [UIFont rpk_boldFontWithSize:33.0f];
		_sourceLabel.textColor = [UIColor rpk_darkGray];
		_sourceLabel.backgroundColor = [UIColor clearColor];
		_sourceLabel.numberOfLines = 0;
		[_sourceLabel ul_enableAutoLayout];
	}
	
	return _sourceLabel;
}

@end

#pragma mark -

NSString *const MVCCellID = @"kMVCCellID";

/********************************
 *  RPKMenuViewController
 ********************************/
@interface RPKMenuViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, RPKGoogleViewControllerDelegate, RPLocationSelectionViewControllerDelegate, RPKAdministratorDelegate>

@property (nonatomic, strong) UILabel *kioskTitle;
@property (nonatomic, strong) UICollectionView *menuSelectionView;
@property (nonatomic, strong) RPKSecuredView *securedView;
@property (nonatomic, strong) RPKKioskViewController *kioskViewController;

@end

@implementation RPKMenuViewController

- (void)dealloc
{
	[self ul_unRegisterAllManagedServices];
	[self unRegisterNotification];
}

#pragma mark - View Life Cycle

- (instancetype)init
{
	if (self = [super init]) {
		[self registerNotification];
	}
	
	return self;
}

- (void)loadView
{
	[super loadView];
	
	self.paddings = UIEdgeInsetsMake(90.0f, 140.0f, 280.0f, 140.0f);
	self.spacings = CGSizeMake(0.0f, 60.0f);
	
	self.view.backgroundColor = [UIColor ul_colorWithR:10 G:53 B:70 A:1];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

    [self.view addSubview:self.kioskTitle];
    [self.view addSubview:self.menuSelectionView];
	[self.view addSubview:self.securedView];
	
	[self.view addConstraints:[self.kioskTitle ul_pinWithInset:UIEdgeInsetsMake(self.paddings.top, 0.0f, kUIViewUnpinInset, 0.0f)]];
	[self.view addConstraints:[self.menuSelectionView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, self.paddings.bottom, self.paddings.right)]];
	[self.view addConstraints:[self.menuSelectionView ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.kioskTitle distance:self.spacings.height topToBottom:NO]];
	[self.view addConstraints:[self.securedView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 80.0f, 100.0f, 80.0f)]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSArray *services = @[[RPService serviceNameFromType:ServiceUpdateSelectedLocation],
						  [RPService serviceNameFromType:ServiceGetUserConfig]];
	[self ul_registerManagedServices:services];
	[[self dataSource] loadData];
	
	[RPNotificationCenter registerObject:self
					 forNotificationName:AuthenticationHandlerAuthenticatedNotification
								 handler:@selector(handleAuthenticatedNotification:)
							   parameter:nil];
}

#pragma mark - ULViewDataBinding Protocol

- (Class)ul_binderClass
{
	return [RPKMenuDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"handleBinderSourceUpdated:":@"menuItems"};
}

- (RPKMenuDataSource *)dataSource
{
	return (RPKMenuDataSource *)[self ul_currentBinderSource];
}

- (void)handleBinderSourceUpdated:(NSArray *)updatedItems
{
	[self.menuSelectionView reloadData];
	
	if (!self.presentedViewController || [self kioskPresent]) {
		if ([[RPAccountManager sharedManager] isAuthenticated]) {
			[self validateSources];
		}
	}
}

- (BOOL)kioskPresent
{
	BOOL kioskPresent = self.presentedViewController != nil;
	kioskPresent = kioskPresent && [self.presentedViewController isKindOfClass:[RPKNavigationController class]];
	kioskPresent = kioskPresent && [[(RPKNavigationController *)self.presentedViewController topViewController] isKindOfClass:[RPKKioskViewController class]];
	
	return kioskPresent;
}

- (void)validateSources
{
	if ([[self dataSource].menuItems count] == 1 && ![self kioskPresent]) {
		//--we only have kiosk
		RPKMenuItem *menuItem = [[self dataSource] menuItemAtIndex:0];
		RPKKioskViewController *timeWebVC = [[RPKKioskViewController alloc] initWithURL:menuItem.itemURL];
		timeWebVC.shouldTimedOut = NO;
		timeWebVC.kioskOnly = YES;
		[timeWebVC setAdministratorDelegate:self];
		RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:timeWebVC];
		[self.navigationController presentViewController:navigationHolder animated:YES completion:NULL];
	} else if ([[self dataSource].menuItems count] > 1 && [self kioskPresent]) {
		[self.navigationController dismissViewControllerAnimated:YES completion:^{}];
	}
}

#pragma mark - Title

- (UILabel *)kioskTitle {
    if (!_kioskTitle) {
        _kioskTitle = [[UILabel alloc] init];
        _kioskTitle.backgroundColor = [UIColor clearColor];
        _kioskTitle.textAlignment = NSTextAlignmentCenter;
		NSString *labelText = NSLocalizedString(@"Please tell us\nwhat you think", nil);
		NSMutableAttributedString *attributedText = [labelText al_attributedStringWithFont:[UIFont rpk_boldFontWithSize:70.0f] textColor:[UIColor whiteColor]];
		[attributedText rp_addLineSpacing:4.0f];
		_kioskTitle.attributedText = attributedText;
		_kioskTitle.numberOfLines = 0;
		[_kioskTitle ul_enableAutoLayout];
    }

    return _kioskTitle;
}

- (void)handleAdministratorGesture:(UIGestureRecognizer *)gesture
{
	[self displayAdministratorView];
}

#pragma mark - Administrator Delegate

- (void)handleAdministratorTask
{
	if (self.presentedViewController) {
		[self.navigationController dismissViewControllerAnimated:YES completion:^{
			[self displayAdministratorView];
		}];
	} else {
		[self displayAdministratorView];
	}
}

#pragma mark - administrative code

- (void)displayAdministratorView
{
	RPAlertController *alertController = [[RPAlertController alloc] initWithTitle:@"" message:@"Enter the administrative code"];
	[alertController addTextFieldWithStyleHandler:^(UITextField *textField) {
		textField.textAlignment = NSTextAlignmentCenter;
		textField.layer.sublayerTransform = CATransform3DMakeTranslation(0, 0, 0); //--override the margin
	}];
	
	__weak RPAlertController *weakPreference = alertController;
	__weak RPKMenuViewController *selfPointer = self;
	
	[alertController addButtonTitle:@"Cancel" style:AlertButtonStyleCancel action:^(RPAlertButton *button) {
		[selfPointer validateSources];
	}];
	
	[alertController addButtonTitle:@"Ok" style:AlertButtonStyleDefault action:^(RPAlertButton *button) {
		UITextField *codeTextField = [[weakPreference textFields] firstObject];
		NSError *error = nil;
		[selfPointer handleAdministratorCode:codeTextField.text error:&error];
		if (error) {
			[selfPointer validateSources];
		}
	}];
	
	[self presentViewController:alertController animated:YES completion:NULL];
}

- (void)handleAdministratorCode:(NSString *)code error:(NSError **)error
{
	if ([code isEqualToString:[[UIApplication rp_administratorCodes] al_objectAtIndex:0]]) {
		UIAccessibilityRequestGuidedAccessSession(NO, ^(BOOL success) {
			if (success) {
				NSLog(@"Exit Single App Mode");
				NSArray *crashArray = @[];
				NSLog(@"Simulate Crash %@", [crashArray objectAtIndex:0]);
			} else {
				NSLog(@"Failed to exit single app mode");
				*error = [NSError errorWithDomain:@"Administrator Error" code:-2100 userInfo:nil];
			}
		});
	} else if ([code isEqualToString:[[UIApplication rp_administratorCodes] al_objectAtIndex:1]]) {
		if ([RPReferenceHandler hasMultiLocation]) {
			RPLocationSelectionViewController *locationSelectionVC = [[RPLocationSelectionViewController alloc] init];
			locationSelectionVC.delegate = self;
			RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:locationSelectionVC];
			[self presentViewController:navigationHolder animated:YES completion:NULL];
		} else {
			*error = [NSError errorWithDomain:@"Administrator Error" code:-2101 userInfo:nil];
		}
	} else {
		*error = [NSError errorWithDomain:@"Administrator Error" code:-2102 userInfo:nil];
	}
}

#pragma mark - RPLocationSelectionView Delegate

- (void)locationSelectionViewControllerDidDismiss
{
	[self validateSources];
}

#pragma mark - Collection View

- (UICollectionViewFlowLayout *)defaultLayout
{
	UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
	flowLayout.minimumInteritemSpacing = 0.0f;
	flowLayout.minimumLineSpacing = 0.0f;
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	flowLayout.sectionInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
	
	return flowLayout;
}

- (UICollectionView *)menuSelectionView
{
	if (!_menuSelectionView) {
		_menuSelectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
											 collectionViewLayout:[self defaultLayout]];
		[_menuSelectionView registerClass:[RPKMenuCell class] forCellWithReuseIdentifier:MVCCellID];
		_menuSelectionView.delegate = self;
		_menuSelectionView.dataSource = self;
		_menuSelectionView.backgroundColor = [UIColor clearColor];
		[_menuSelectionView ul_enableAutoLayout];
	}
	
	return _menuSelectionView;
}

#pragma mark - Collection View Delegate / DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger count = [[self dataSource].menuItems count];
	return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:MVCCellID forIndexPath:indexPath];
	menuCell.backgroundColor = [UIColor clearColor];
	menuCell.index = indexPath.item;
	
	RPKMenuItem *menuItem = [[self dataSource] menuItemAtIndex:indexPath.item];
	[menuCell assignModel:menuItem forIndexPath:indexPath];
	
	return menuCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[collectionView deselectItemAtIndexPath:indexPath animated:YES];
	
	RPKMenuItem *menuItem = [[self dataSource] menuItemAtIndex:indexPath.item];
	RPKTimedWebViewController *timeWebVC = nil;
	
	RPKAnalyticEvent *sourceSelectEvent = [RPKAnalyticEvent analyticEvent:AnalyticEventSourceSelect];
	
	if (menuItem.itemType == MenuTypeGoogle) {
		timeWebVC = [[RPKGoogleViewController alloc] initWithURL:menuItem.itemURL];
		[(RPKGoogleViewController *)timeWebVC setDelegate:self];
		[timeWebVC setAdministratorDelegate:self];
		[sourceSelectEvent addProperty:PropertySourceName value:kAnalyticSourceGoogle];
	} else {
		//--do not create new kiosk view if we want to retain
		self.kioskViewController = [[RPKKioskViewController alloc] initWithURL:menuItem.itemURL];
		self.kioskViewController.administratorDelegate = self;
	
		timeWebVC = self.kioskViewController;
		[sourceSelectEvent addProperty:PropertySourceName value:kAnalyticSourceKiosk];
	}
	
	[sourceSelectEvent send];
	RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:timeWebVC];
	[self.navigationController presentViewController:navigationHolder animated:YES completion:NULL];

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize itemSize = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height / 2 - 20.0f);
	
	return itemSize;
}

#pragma mark - RPKGoogleViewController Delegate

- (void)googleViewControllerShouldSignUp:(RPKGoogleViewController *)googleViewController
{
	[self dismissViewControllerAnimated:YES completion:^{
		RPKMenuItem *kioskItem = [[self dataSource] menuItemAtIndex:0];
		RPKKioskViewController *kioskViewController = [[RPKKioskViewController alloc] initWithURL:kioskItem.itemURL];
		RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:kioskViewController];
		[self.navigationController presentViewController:navigationHolder animated:YES completion:NULL];
	}];
}

#pragma mark - Secured View

- (RPKSecuredView *)securedView
{
	if (!_securedView) {
		_securedView = [[RPKSecuredView alloc] init];
		_securedView.backgroundColor = [UIColor clearColor];
		[_securedView setLockBackgroundColor:self.view.backgroundColor];
		[_securedView ul_enableAutoLayout];
		[_securedView ul_fixedSize:CGSizeMake(0.0f, 110.0f) priority:UILayoutPriorityDefaultHigh];
		
		NSString *securedMessage = NSLocalizedString(@"We never save or share your personal information.", nil);
		NSString *boldText = NSLocalizedString(@"never", nil);
		NSMutableAttributedString *attributedMessage = [securedMessage al_attributedStringWithFont:[UIFont rpk_fontWithSize:20.0f] textColor:[UIColor whiteColor]];
		[attributedMessage addAttribute:NSFontAttributeName value:[UIFont rpk_extraBoldFontWithSize:20.0f] range:[securedMessage rangeOfString:boldText]];
		[_securedView setSecuredMessage:attributedMessage];
	}
	
	return _securedView;
}

#pragma mark - Notification

- (void)handleAuthenticationNeededNotification:(NSNotification *)notification {
	RPKLoginViewController *loginViewController = [[RPKLoginViewController alloc] init];
	[self.navigationController presentViewController:loginViewController animated:YES completion:NULL];
}

- (void)handleAuthenticatedNotification:(NSNotification *)notification {
	if ([RPReferenceHandler hasMultiLocation] && [[self dataSource].selectedLocationID length] == 0) {
		RPLocationSelectionViewController *locationSelectionVC = [[RPLocationSelectionViewController alloc] init];
		locationSelectionVC.delegate = self;
		RPKNavigationController *navigationHolder = [[RPKNavigationController alloc] initWithRootViewController:locationSelectionVC];
		[self.navigationController presentViewController:navigationHolder animated:YES completion:NULL];
	} else {
		[self validateSources];
	}
}

- (void)registerNotification
{
	[RPNotificationCenter registerObject:self
					 forNotificationName:AuthenticationHandlerAuthenticationRequiredNotification
								 handler:@selector(handleAuthenticationNeededNotification:)
							   parameter:nil];
}

- (void)unRegisterNotification
{
	[RPNotificationCenter unRegisterAllNotificationForObject:self];
}

@end
