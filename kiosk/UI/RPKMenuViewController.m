//
//  RPKMenuViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <TOWebViewController/TOWebViewController.h>

#import "RPKMenuViewController.h"
#import "RPKCollectionViewCell.h"

#import "UIImage+RPK.h"

/********************************
 *  RPKMenuCell
 ********************************/
@interface RPKMenuCell : RPKCollectionViewCell

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *largeTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *whiteBackground;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f);
	self.spacings = CGSizeMake(10.0f, 10.0f);
	
	[self.contentView addSubview:self.whiteBackground];
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.largeTitleLabel];
	[self.contentView addSubview:self.detailLabel];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
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
	
	self.view.backgroundColor = [UIColor lightGrayColor];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	[self.view addSubview:self.collectionView];
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
	flowLayout.minimumInteritemSpacing = 0;
	flowLayout.sectionInset = UIEdgeInsetsZero;
	flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
	
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
	}
	
	return _collectionView;
}

#pragma mark - Collection View Delegate / DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [[self dataSource].menuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuCell *menuCell = [collectionView dequeueReusableCellWithReuseIdentifier:MVCCellID forIndexPath:indexPath];
	menuCell.backgroundColor = [UIColor greenColor];
	menuCell.index = indexPath.item;
	
	RPKMenuItem *menuItem = [[self dataSource] menuItemAtIndex:indexPath.item];
	[menuCell assignModel:menuItem forIndexPath:indexPath];
	
	return menuCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 2);
}

@end
