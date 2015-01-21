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

#define kMCLogoImageSize			CGSizeMake(150.0f, 150.0f)

#pragma mark -

/********************************
 *  RPKMenuCell
 ********************************/
@interface RPKMenuCell : RPKCollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *buttonBackgroundView;
@property (nonatomic, strong) UILabel *sourceLabel;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(25.0f, 10.0f, 25.0f, 0.0f);
	self.spacings = CGSizeMake(20.0f, 0.0f);
	
	[self.contentView addSubview:self.buttonBackgroundView];
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.sourceLabel];
	
	[self.contentView addConstraints:[self.buttonBackgroundView ul_pinWithInset:UIEdgeInsetsZero]];
	[self.contentView addConstraints:[self.sourceLabel ul_horizontalAlign:NSLayoutFormatAlignAllCenterY withView:self.logoImageView distance:self.spacings.width leftToRight:NO]];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.logoImageView.frame = [self logoImageViewFrame];
}

#pragma mark - Override

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
	self.sourceLabel.text = menuItem.itemTitle;
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

- (UILabel *)sourceLabel
{
	if (!_sourceLabel) {
		_sourceLabel = [[UILabel alloc] init];
		_sourceLabel.font = [UIFont rpk_boldFontWithSize:35.0f];
		_sourceLabel.textColor = [UIColor rpk_darkGray];
		_sourceLabel.backgroundColor = [UIColor clearColor];
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
@interface RPKMenuViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *kioskTitle;
@property (nonatomic, strong) UILabel *kioskSubtitle;
@property (nonatomic, strong) UICollectionView *menuSelectionView;
@property (nonatomic, strong) RPKSecuredView *securedView;

@end

@implementation RPKMenuViewController

#pragma mark - View Life Cycle

- (void)loadView
{
	[super loadView];
	
	self.paddings = UIEdgeInsetsMake(130.0f, 140.0f, 280.0f, 140.0f);
	self.spacings = CGSizeMake(0.0f, 60.0f);
	
	self.view.backgroundColor = [UIColor ul_colorWithR:246 G:246 B:246 A:1];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

    [self.view addSubview:self.kioskTitle];
    [self.view addSubview:self.kioskSubtitle];
    [self.view addSubview:self.menuSelectionView];
	[self.view addSubview:self.securedView];
	
	[self.view addConstraints:[self.kioskTitle ul_pinWithInset:UIEdgeInsetsMake(self.paddings.top, 0.0f, kUIViewUnpinInset, 0.0f)]];
	[self.view addConstraints:[self.kioskSubtitle ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.kioskTitle distance:kUIViewAquaDistance topToBottom:NO]];
	[self.view addConstraints:[self.menuSelectionView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, self.paddings.left, self.paddings.bottom, self.paddings.right)]];
	[self.view addConstraints:[self.menuSelectionView ul_verticalAlign:NSLayoutFormatAlignAllCenterX withView:self.kioskSubtitle distance:self.spacings.height topToBottom:NO]];
	[self.view addConstraints:[self.securedView ul_pinWithInset:UIEdgeInsetsMake(kUIViewUnpinInset, 80.0f, 100.0f, 80.0f)]];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[self dataSource] loadData];
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
}

#pragma mark - Title

- (UILabel *)kioskTitle {
    if (!_kioskTitle) {
        _kioskTitle = [[UILabel alloc] init];
        _kioskTitle.textColor = [UIColor rpk_defaultBlue];
        _kioskTitle.font = [UIFont rpk_fontWithSize:72.0f];
        _kioskTitle.backgroundColor = [UIColor clearColor];
        _kioskTitle.textAlignment = NSTextAlignmentCenter;
        _kioskTitle.text = NSLocalizedString(@"Leave a Review", nil);
		[_kioskTitle ul_enableAutoLayout];
    }

    return _kioskTitle;
}

- (UILabel *)kioskSubtitle {
    if (!_kioskSubtitle) {
        _kioskSubtitle = [[UILabel alloc] init];
        _kioskSubtitle.textColor = [UIColor ul_colorWithR:190 G:162 B:207 A:1.0f];
        _kioskSubtitle.textAlignment = NSTextAlignmentCenter;
        _kioskSubtitle.font = [UIFont rpk_fontWithSize:27.0f];
        _kioskSubtitle.backgroundColor = [UIColor clearColor];
        _kioskSubtitle.text = NSLocalizedString(@"Please select a review source", nil);
		[_kioskSubtitle ul_enableAutoLayout];
    }

    return _kioskSubtitle;
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
	
	if ([menuItem isKindOfClass:[RPKGoogleItem class]]) {
		RPKGoogleViewController *googleWebVC = [[RPKGoogleViewController alloc] initWithURL:menuItem.itemURL];
		googleWebVC.logoutURL = [(RPKGoogleItem *)menuItem logoutURL];
		[self.navigationController presentViewController:googleWebVC animated:YES completion:NULL];
	} else {
		RPKKioskViewController *kioskWebVC = [[RPKKioskViewController alloc] initWithURL:menuItem.itemURL];
		[self.navigationController presentViewController:kioskWebVC animated:YES completion:NULL];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize itemSize = CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height / 2 - 20.0f);
	
	return itemSize;
}

#pragma mark - Secured View

- (RPKSecuredView *)securedView
{
	if (!_securedView) {
		_securedView = [[RPKSecuredView alloc] init];
		_securedView.backgroundColor = [UIColor clearColor];
		[_securedView setLockBackgroundColor:[UIColor rpk_backgroundColor]];
		[_securedView ul_enableAutoLayout];
		[_securedView ul_fixedSize:CGSizeMake(0.0f, 110.0f) priority:UILayoutPriorityDefaultHigh];
	}
	
	return _securedView;
}

@end
