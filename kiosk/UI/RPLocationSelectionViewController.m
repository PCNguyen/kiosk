//
//  RPLocationSelectionViewController.m
//  Reputation
//
//  Created by PC Nguyen on 6/9/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPLocationSelectionViewController.h"
#import "RPFixedHeaderTableView.h"
#import "RPNotificationCenter.h"
#import "UIViewController+Alert.h"
#import "RPKTableViewCell.h"
#import "RPAccountManager.h"

#define kLSVCSearchBarHeight				50.0f
#define kLSVCSectionAll						0

NSString *const LSVCCellID = @"LSVCCellID";

@interface RPKLocationCell : RPKTableViewCell

@property (nonatomic, strong) UIImageView *googleIndicator;
@property (nonatomic, strong) UIImageView *kioskIndicator;
@property (nonatomic, strong) UIImageView *carsIndicator;

@end

@implementation RPKLocationCell

- (void)commonInit
{
	self.paddings = UIEdgeInsetsMake(12.0f, 0.0f, 12.0f, 35.0f);
	self.spacings = CGSizeMake(10.0f, 0.0f);
	
	self.textLabel.font = [UIFont rpk_boldFontWithSize:18.0f];
	[self.contentView addSubview:self.googleIndicator];
	[self.contentView addSubview:self.kioskIndicator];
    [self.contentView addSubview:self.carsIndicator];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	self.textLabel.textColor = [UIColor blackColor];
	self.googleIndicator.highlighted = NO;
	self.carsIndicator.highlighted = NO;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.kioskIndicator.frame = [self kioskIndicatorFrame];
    self.carsIndicator.frame = [self carsIndicatorFrame:self.kioskIndicator.frame];
    self.googleIndicator.frame = [self googleIndicatorFrame:self.carsIndicator.frame];
}

- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath
{
	RPKLocationSelection *selection = (RPKLocationSelection *)model;
	self.textLabel.text = selection.selectionLabel;
	if (selection.isSelected) {
		self.textLabel.textColor = [UIColor rpk_defaultBlue];
	}
	
	if (!(selection.enabledSources & LocationSourceKiosk)) {
		self.textLabel.textColor = [UIColor rpk_lightGray];
	}

	if (selection.enabledSources & LocationSourceGoogle) {
		self.googleIndicator.highlighted = YES;
    }

    if (selection.enabledSources & LocationSourceCars) {
        self.carsIndicator.highlighted = YES;
    }
}

#pragma mark - UI Elements

- (CGRect)googleIndicatorFrame:(CGRect)preferenceFrame
{
	CGFloat yOffset = preferenceFrame.origin.y;
	CGFloat height = preferenceFrame.size.height;
	CGFloat width = height;
	CGFloat xOffset = preferenceFrame.origin.x - width - self.spacings.width;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)googleIndicator
{
	if (!_googleIndicator) {
		_googleIndicator = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_small_google_disabled.png"]
											 highlightedImage:[UIImage rpk_bundleImageNamed:@"icon_small_google.png"]];
		_googleIndicator.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _googleIndicator;
}

- (CGRect)kioskIndicatorFrame
{
	CGFloat yOffset = self.paddings.top;
	CGFloat height = self.bounds.size.height - yOffset - self.paddings.bottom;
	CGFloat width = height;
	CGFloat xOffset = self.bounds.size.width - self.paddings.right - width;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)kioskIndicator
{
	if (!_kioskIndicator) {
		_kioskIndicator = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_quicksurvey.png"]];
		_kioskIndicator.contentMode = UIViewContentModeScaleAspectFit;
	}
	
	return _kioskIndicator;
}

- (CGRect)carsIndicatorFrame:(CGRect)preferenceFrame
{
    CGFloat yOffset = preferenceFrame.origin.y;
    CGFloat height = preferenceFrame.size.height;
    CGFloat width = height;
    CGFloat xOffset = preferenceFrame.origin.x - width - self.spacings.width;

    return CGRectMake(xOffset, yOffset, width, height);
}

- (UIImageView *)carsIndicator
{
    if(!_carsIndicator) {
        _carsIndicator = [[UIImageView alloc] initWithImage:[UIImage rpk_bundleImageNamed:@"icon_small_cars_disabled.png"]
                                           highlightedImage:[UIImage rpk_bundleImageNamed:@"icon_small_cars.png"]];
        _carsIndicator.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _carsIndicator;
}

@end

@interface RPLocationSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) RPFixedHeaderTableView *locationTableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation RPLocationSelectionViewController

- (void)dealloc
{
	[self ul_unRegisterAllManagedServices];
}

- (void)loadView
{
	[super loadView];
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"Select Locations";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSString *configService = [RPService serviceNameFromType:ServiceGetUserConfig];
	[self ul_registerManagedService:configService];
	[[self selectionDataSource] loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self configureNavigation];
	
	[self.view addSubview:self.locationTableView];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	
	self.locationTableView.frame = [self tableViewFrame];
}

#pragma mark - Navigation

- (void)configureNavigation
{
	[self refreshNavigation];
}

- (void)refreshNavigation
{
	NSInteger selectedLocationsCount = [[[self selectionDataSource] selectedLocations] count];
	
	if (selectedLocationsCount > 0) {
		self.title = [NSString stringWithFormat:@"Select Locations (%ld)", (long)selectedLocationsCount];
		self.navigationItem.rightBarButtonItem.enabled = YES;
	} else {
		self.title = @"Select Locations";
		self.navigationItem.rightBarButtonItem.enabled = NO;
	}

}

- (void)handleLocationSelected
{
	NSMutableArray *selectedLocations = [[self selectionDataSource] selectedLocations];
	Location *location = [[self selectionDataSource] locationForCode:[selectedLocations firstObject]];
	if (location) {
		[RPKAnalyticEvent registerSuperPropertiesForUser:[[RPAccountManager sharedManager] userAccount] location:location];
		[RPKAnalyticEvent sendEvent:AnalyticEventLocationSelect];
	}
	
	if ([self.delegate respondsToSelector:@selector(locationSelectionViewController:selectLocations:)]) {
		[self.delegate locationSelectionViewController:self selectLocations:selectedLocations];
	}
	
	[self dismissViewController];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.delegate respondsToSelector:@selector(locationSelectionViewControllerDidDismiss)]) {
			[self.delegate locationSelectionViewControllerDidDismiss];
		}
	}];
}

#pragma mark - Data Binding

- (Class)ul_binderClass
{
	return [RPLocationSelectionDataSource class];
}

- (NSDictionary *)ul_bindingInfo
{
	return @{@"updateLocationList:":@"locations"};
}

- (void)updateLocationList:(NSArray *)locationList
{
	[self.locationTableView.tableView reloadData];
}

- (RPLocationSelectionDataSource *)selectionDataSource
{
	return (RPLocationSelectionDataSource *)[self ul_currentBinderSource];
}

#pragma mark - TableView

- (CGRect)tableViewFrame
{
	return self.view.bounds;
}

- (RPFixedHeaderTableView *)locationTableView
{
	if (!_locationTableView) {
		_locationTableView = [[RPFixedHeaderTableView alloc] initWithFrame:[self tableViewFrame]
																	 style:UITableViewStylePlain
														   fixedHeaderView:[self searchBar]];
		_locationTableView.delegate = self;
		_locationTableView.dataSource = self;
		_locationTableView.tableView.separatorColor = [UIColor rpk_borderColor];
		_locationTableView.tableView.separatorInset = UIEdgeInsetsZero;
	}
	
	return _locationTableView;
}

#pragma mark - TableView Delegate / DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	NSInteger count = [[self selectionDataSource] sectionCount];
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger rowCount = [[self selectionDataSource] locationCountInSection:section];
	
	return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RPKLocationCell *locationCell = [tableView dequeueReusableCellWithIdentifier:LSVCCellID];
	
	if (!locationCell) {
		locationCell = [[RPKLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LSVCCellID];
		locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	RPKLocationSelection *selection = [[self selectionDataSource] locationAtIndexPath:indexPath];
	[locationCell assignModel:selection forIndexPath:indexPath];

	return locationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[self selectionDataSource] toggleSelectAll:NO];
	[[self selectionDataSource] toggleSelectionAtIndexPath:indexPath];
	
	//--confirmation
	RPKSelection *selection = [[self selectionDataSource] locationAtIndexPath:indexPath];
	RPAlertController *alertController = [[RPAlertController alloc] initWithTitle:NSLocalizedString(@"Confirm Location", nil)
																		  message:[NSString stringWithFormat:NSLocalizedString(@"Open Kiosk for %@?", nil), selection.selectionLabel]];
	__weak RPLocationSelectionViewController *selfPointer = self;
	[alertController addButtonTitle:@"Cancel" style:AlertButtonStyleCancel action:^(RPAlertButton *alertButton) {
		[selfPointer.locationTableView.tableView reloadData];
		[selfPointer refreshNavigation];
	}];
	
	[alertController addButtonTitle:@"OK" style:AlertButtonStyleDefault action:^(RPAlertButton *alertButton) {
		[[selfPointer selectionDataSource] persistSelectedLocation];
		[selfPointer handleLocationSelected];
	}];
	
	[self presentViewController:alertController animated:YES completion:NULL];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return [[self selectionDataSource] indexTitles];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0f;
}

#pragma mark - Search Bar

- (CGRect)searchBarFrame
{
	CGFloat xOffset = 0.0f;
	CGFloat yOffset = 0.0f;
	CGFloat width = self.view.bounds.size.width;
	CGFloat height = kLSVCSearchBarHeight;
	
	return CGRectMake(xOffset, yOffset, width, height);
}

- (UISearchBar *)searchBar
{
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc] initWithFrame:[self searchBarFrame]];
		_searchBar.delegate = self;
		_searchBar.placeholder = @"Search";
		
		UIColor *tintColor = [UIColor ul_colorWithR:246 G:246 B:246 A:1.0f];
		_searchBar.backgroundImage = [UIImage ul_imageWithColor:tintColor size:CGSizeMake(1.0f, 1.0f)];
	}
	
	return _searchBar;
}

- (BOOL)inSearchMode
{
	return (self.searchBar.text.length > 0);
}

#pragma mark - Search Bar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	searchBar.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[[self selectionDataSource] applyFilterText:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	searchBar.showsCancelButton = NO;
}

#pragma mark - Notification

- (void)registerNotification
{
	[RPNotificationCenter registerObject:self
					 forNotificationName:UIKeyboardDidShowNotification
								 handler:@selector(handleKeyboardNotification:)
							   parameter:nil];
	[RPNotificationCenter registerObject:self
					 forNotificationName:UIKeyboardWillHideNotification
								 handler:@selector(handleKeyboardNotification:)
							   parameter:nil];
}

- (void)unRegisterNotification
{
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardDidShowNotification parameter:nil];
	[RPNotificationCenter unRegisterObject:self forNotificationName:UIKeyboardWillHideNotification parameter:nil];
}

- (void)handleKeyboardNotification:(NSNotification *)notification
{
	BOOL visible = [[notification name] isEqualToString:UIKeyboardDidShowNotification];
	
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect convertedKeyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardHeight = convertedKeyboardRect.size.height;
	
	if (visible) {
		CGFloat adjustment = keyboardHeight / 2;
		CGRect adjustedFrame = CGRectInset([self tableViewFrame], 0.0f, adjustment);;
		self.locationTableView.frame = CGRectOffset(adjustedFrame, 0.0f, - adjustment);
	} else {
		self.locationTableView.frame = [self tableViewFrame];
	}
}

#pragma mark - Private

- (BOOL)isAllSelected
{
	RPLocationSelectionDataSource *dataSource = [self selectionDataSource];
	NSArray *selectedLocations = [dataSource selectedLocations];
	BOOL isSelected = ([[dataSource allLocations] count] == [selectedLocations count]);
	return isSelected;
}

@end
