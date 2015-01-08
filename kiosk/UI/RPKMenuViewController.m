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
#import "RPKNavigationController.h"

#import "UIImage+RPK.h"

#define kMCLogoImageSize			CGSizeMake(100.0f, 100.0f)

#pragma mark -

/********************************
 *  RPKMenuCell
 ********************************/
@interface RPKMenuCell : RPKCollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f);
	self.spacings = CGSizeMake(0.0f, 30.0f);
	
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.detailLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.detailLabel.frame = [self detailLabelFrame];
	self.logoImageView.frame = [self logoImageFrame:self.detailLabel.frame];
	
	[self.logoImageView ul_round];
}

#pragma mark - Override

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
	NSMutableAttributedString *attributedString = [menuItem.itemDetail al_attributedStringWithFont:[UIFont systemFontOfSize:40.0f] textColor:[UIColor lightGrayColor]];
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
		_detailLabel.textAlignment = NSTextAlignmentCenter;
		_detailLabel.font = [UIFont systemFontOfSize:30.0f];
		_detailLabel.numberOfLines = 0;
		_detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_detailLabel.textColor = [UIColor ul_colorWithR:73 G:189 B:236 A:1.0f];
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

@end

@implementation RPKMenuViewController

#pragma mark - View Life Cycle

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	[self.view addSubview:self.collectionView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[self dataSource] loadData];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.collectionView.frame = self.view.bounds;	
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
		RPKWebViewController *webVC = [[RPKWebViewController alloc] initWithURL:menuItem.itemURL];
		[self.navigationController presentViewController:webVC animated:YES completion:NULL];
	}
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 2 - 20.0f);
	
	return itemSize;
}

@end
