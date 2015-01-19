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

#import "UIImage+RPK.h"

#define kMCLogoImageSize			CGSizeMake(150.0f, 150.0f)

#pragma mark -

/********************************
 *  RPKMenuCell
 ********************************/
@interface RPKMenuCell : RPKCollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *logoImageBorder;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
	self.spacings = CGSizeMake(0.0f, 30.0f);
	
	[self.contentView addSubview:self.logoImageBorder];
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.detailLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.detailLabel.frame = [self detailLabelFrame];
	self.logoImageView.frame = [self logoImageFrame:self.detailLabel.frame];
	self.logoImageBorder.frame = CGRectInset(self.logoImageView.frame, -5.0f, -5.0f);
	[self.logoImageView ul_round];
	[self.logoImageBorder ul_round];
}

#pragma mark - Override

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	
	NSString *concateTitle = [NSString stringWithFormat:@"%@\n%@",menuItem.itemTitle, menuItem.itemDetail];
	
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
	NSMutableAttributedString *attributedString = [concateTitle al_attributedStringWithFont:[UIFont systemFontOfSize:25.0f] textColor:[UIColor whiteColor]];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:5];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	
	[attributedString addAttribute:NSParagraphStyleAttributeName
							 value:paragraphStyle
							 range:[concateTitle al_fullRange]];
	
	[attributedString addAttribute:NSFontAttributeName
							 value:[UIFont systemFontOfSize:35.0f]
							 range:[menuItem.itemTitle al_fullRange]];
	[attributedString addAttribute:NSForegroundColorAttributeName
							 value:[UIColor yellowColor]
							 range:[menuItem.itemTitle al_fullRange]];
	self.detailLabel.attributedText = attributedString;
}

#pragma mark - Logo Image

- (CGRect)logoImageFrame:(CGRect)bottomFrame
{
	CGFloat width = kMCLogoImageSize.width;
	CGFloat height = kMCLogoImageSize.height;
	CGFloat xOffset = (self.bounds.size.width - width) / 2;
	CGFloat yOffset = bottomFrame.origin.y - self.spacings.height - height;
	
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

- (UIView *)logoImageBorder
{
	if (!_logoImageBorder) {
		_logoImageBorder = [[UIView alloc] initWithFrame:CGRectZero];
		_logoImageBorder.backgroundColor = [UIColor whiteColor];
	}
	
	return _logoImageBorder;
}

#pragma mark - Detail Label

- (CGRect)detailLabelFrame
{
	CGFloat xOffset = self.paddings.left;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	CGFloat height = [self.detailLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
	CGFloat totalHeight = height + kMCLogoImageSize.height + self.spacings.height;
	CGFloat yOffset = (self.bounds.size.height - totalHeight) / 2 + kMCLogoImageSize.height + self.spacings.height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)detailLabel
{
	if (!_detailLabel) {
		_detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_detailLabel.numberOfLines = 0;
	}
	
	return _detailLabel;
}

@end

#pragma mark -

NSString *const MVCCellID = @"kMVCCellID";

/********************************
 *  RPKMenuViewController
 ********************************/
@interface RPKMenuViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *dividerView;
@property (nonatomic, strong) UIImageView *blurBackground;

@end

@implementation RPKMenuViewController

#pragma mark - View Life Cycle

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor ul_colorWithR:0 G:0 B:0 A:1];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	[self.view addSubview:self.blurBackground];
	[self.view addSubview:self.collectionView];
	[self.view addSubview:self.dividerView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[self dataSource] loadData];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.blurBackground.frame = self.view.bounds;
	[self.collectionView.collectionViewLayout invalidateLayout];
	self.collectionView.frame = self.view.bounds;
	self.dividerView.frame = [self dividerViewFrame];
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
	[self.collectionView reloadData];
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

- (UICollectionView *)collectionView
{
	if (!_collectionView) {
		_collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
											 collectionViewLayout:[self defaultLayout]];
		[_collectionView registerClass:[RPKMenuCell class] forCellWithReuseIdentifier:MVCCellID];
		_collectionView.delegate = self;
		_collectionView.dataSource = self;
		_collectionView.backgroundColor = [UIColor clearColor];
	}
	
	return _collectionView;
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
	CGSize itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 2 - 20.0f);
	
	return itemSize;
}

#pragma mark - Divider View

- (CGRect)dividerViewFrame
{
	CGFloat xOffset = 100.0f;
	CGFloat width = self.view.bounds.size.width - 2*xOffset;
	CGFloat height = 2.0f;
	CGFloat yOffset = (self.view.bounds.size.height - height) / 2;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIView *)dividerView
{
	if (!_dividerView) {
		_dividerView = [[UIView alloc] initWithFrame:CGRectZero];
		_dividerView.backgroundColor = [UIColor whiteColor];
	}
	
	return _dividerView;
}

#pragma mark - Background

- (UIImageView *)blurBackground
{
	if (!_blurBackground) {
		_blurBackground = [[UIImageView alloc] initWithImage:nil];
		_blurBackground.contentMode = UIViewContentModeScaleAspectFill;
		_blurBackground.image = [[UIImage rpk_bundleImageNamed:@"menuBackground.jpg"] applyTintEffectWithColor:[UIColor blackColor]];
	}
	
	return _blurBackground;
}

@end
