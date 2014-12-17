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

#pragma mark -

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
	
	self.largeTitleLabel.frame = [self largeTitleLabelFrame];
	self.logoImageView.frame = [self logoImageFrame:self.largeTitleLabel.frame];
	self.detailLabel.frame = [self detailLabelFrame:self.logoImageView.frame];
}

#pragma mark - Override

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKMenuItem *menuItem = (RPKMenuItem *)model;
	
	self.logoImageView.image = [UIImage rpk_bundleImageNamed:menuItem.imageName];
	self.largeTitleLabel.text = menuItem.itemTitle;
	self.detailLabel.text = menuItem.itemDetail;
}

#pragma mark - Title

- (CGRect)largeTitleLabelFrame
{
	CGFloat xOffset = self.paddings.left;
	CGFloat yOffset = self.paddings.top;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	CGFloat height = [self.largeTitleLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)largeTitleLabel
{
	if (!_largeTitleLabel) {
		_largeTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_largeTitleLabel.textAlignment = NSTextAlignmentLeft;
		_largeTitleLabel.textColor = [UIColor darkGrayColor];
		_largeTitleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
		_largeTitleLabel.numberOfLines = 1;
		_largeTitleLabel.adjustsFontSizeToFitWidth = YES;
	}
	
	return _largeTitleLabel;
}

#pragma mark - Logo Image

- (CGRect)logoImageFrame:(CGRect)topFrame
{
	CGFloat xOffset = topFrame.origin.x;
	CGFloat yOffset = topFrame.origin.y + topFrame.size.height + self.spacings.height;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
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

#pragma mark - Detail Label

- (CGRect)detailLabelFrame:(CGRect)leftFrame
{
	CGFloat xOffset = leftFrame.origin.x + leftFrame.size.width + self.spacings.width;
	CGFloat yOffset = leftFrame.origin.y;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right;
	CGFloat height = leftFrame.size.height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)detailLabel
{
	if (!_detailLabel) {
		_detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_detailLabel.textAlignment = NSTextAlignmentLeft;
		_detailLabel.font = [UIFont systemFontOfSize:14.0f];
		_detailLabel.numberOfLines = 0;
		_detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_detailLabel.textColor = [UIColor lightGrayColor];
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
