//
//  RPKMenuViewController.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "RPKMenuViewController.h"
#import "RPKCollectionViewCell.h"
#import "RPKKioskViewController.h"

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
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation RPKMenuCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(20.0f, 40.0f, 40.0f, 40.0f);
	self.spacings = CGSizeMake(20.0f, 10.0f);
	
	[self.contentView addSubview:self.whiteBackground];
	[self.contentView addSubview:self.logoImageView];
	[self.contentView addSubview:self.largeTitleLabel];
	[self.contentView addSubview:self.detailLabel];
	[self.contentView addSubview:self.submitButton];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.largeTitleLabel.frame = [self largeTitleLabelFrame];
	self.logoImageView.frame = [self logoImageFrame:self.largeTitleLabel.frame];
	self.detailLabel.frame = [self detailLabelFrame:self.logoImageView.frame];
	self.whiteBackground.frame = [self backgroundFrame];
	self.submitButton.frame = [self submitButtonFrame];
	
	[self.logoImageView ul_round];
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
		_largeTitleLabel.textColor = [UIColor whiteColor];
		_largeTitleLabel.font = [UIFont boldSystemFontOfSize:110.0f];
		_largeTitleLabel.numberOfLines = 1;
		_largeTitleLabel.adjustsFontSizeToFitWidth = YES;
	}
	
	return _largeTitleLabel;
}

#pragma mark - Logo Image

- (CGRect)logoImageFrame:(CGRect)topFrame
{
	CGFloat yOffset = topFrame.origin.y + topFrame.size.height + self.spacings.height;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom - self.spacings.height;
	CGFloat width = height;
	CGFloat xOffset = self.bounds.size.width - width - self.paddings.right;
	
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

- (CGRect)detailLabelFrame:(CGRect)rightFrame
{
	CGFloat yOffset = rightFrame.origin.y;
	CGFloat xOffset = self.paddings.left;
	CGFloat width = rightFrame.origin.x - xOffset - self.spacings.width;
	CGFloat height = [self.detailLabel sizeThatFits:CGSizeMake(width, MAXFLOAT)].height;
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UILabel *)detailLabel
{
	if (!_detailLabel) {
		_detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_detailLabel.textAlignment = NSTextAlignmentLeft;
		_detailLabel.font = [UIFont systemFontOfSize:45.0f];
		_detailLabel.numberOfLines = 0;
		_detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
		_detailLabel.textColor = [UIColor ul_colorWithR:73 G:189 B:236 A:1.0f];
	}
	
	return _detailLabel;
}

#pragma mark - Background

- (CGRect)backgroundFrame
{
	CGFloat xOffset = self.paddings.left / 2;
	CGFloat yOffset = self.paddings.top / 2;
	CGFloat width = self.bounds.size.width - xOffset - self.paddings.right / 2;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom / 4;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIView *)whiteBackground
{
	if (!_whiteBackground) {
		_whiteBackground = [[UIView alloc] initWithFrame:CGRectZero];
		_whiteBackground.backgroundColor = [UIColor ul_colorWithR:29 G:89 B:124 A:1.0f];
		_whiteBackground.layer.cornerRadius = 10.0f;
		_whiteBackground.layer.masksToBounds = YES;
		_whiteBackground.layer.borderWidth = 3.0f;
		_whiteBackground.layer.borderColor = [[UIColor ul_colorWithR:23 G:124 B:179 A:1.0f] CGColor];
	}
	
	return _whiteBackground;
}

#pragma mark - Submit Button

- (CGRect)submitButtonFrame
{
	CGFloat xOffset = self.paddings.left;
	CGFloat height = 80.0f;
	CGFloat width = 100.0f;
	CGFloat yOffset = self.bounds.size.height - self.paddings.bottom - self.spacings.height - height;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIButton *)submitButton
{
	if (!_submitButton) {
		_submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_submitButton setBackgroundImage:[UIImage rpk_bundleImageNamed:@"icon_review_submit.png"] forState:UIControlStateNormal];
	}
	
	return _submitButton;
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
		_collectionView.backgroundColor = [UIColor ul_colorWithR:12.0f G:79.0f B:120.0f A:1.0f];
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
	RPKKioskViewController *webViewController = [[RPKKioskViewController alloc] initWithURL:menuItem.itemURL];
	[self.navigationController presentViewController:webViewController animated:YES completion:NULL];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGSize itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height / 2 - 20.0f);
	
	return itemSize;
}

@end
