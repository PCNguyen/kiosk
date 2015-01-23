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
#import "RPReferenceHandler.h"

#define kLSVCSearchBarHeight				50.0f
#define kLSVCSectionAll						0

NSString *const RPLocationSelectionViewControllerCellIdentifier = @"RPLocationSelectionViewControllerCellIdentifier";

@interface RPLocationSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) RPFixedHeaderTableView *locationTableView;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation RPLocationSelectionViewController

- (void)dealloc
{
	[self ul_unRegisterAllManagedServices];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"Select Locations";

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

#pragma mark - Navigation

- (void)configureNavigation
{
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.leftBarButtonItem = [self backButtonItem];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																				action:@selector(handleDoneButtonTapped:)];
	
	self.navigationItem.rightBarButtonItem = doneButton;
	
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

- (UIBarButtonItem *)backButtonItem
{
	UIImage *backButtonImage = [UIImage rpk_bundleImageNamed:@"icon_back.png"];
	UIBarButtonItem *backButton = [UIBarButtonItem ul_barButtonItemWithImage:backButtonImage target:self action:@selector(handleBackButtonItemTapped:)];
	return backButton;
}

- (void)handleBackButtonItemTapped:(id)sender
{
	[self dismissViewController];
}

- (void)handleDoneButtonTapped:(id)sender
{
	NSMutableArray *selectedLocations = [[self selectionDataSource] selectedLocations];
	
	if ([[self selectionDataSource] applyUserSettings]) {
		[RPReferenceHandler sendLocationSettings:selectedLocations];
	}
	
	if ([self.delegate respondsToSelector:@selector(locationSelectionViewController:selectLocations:)]) {
		[self.delegate locationSelectionViewController:self selectLocations:selectedLocations];
	}
	
	[self dismissViewController];
}

- (void)dismissViewController
{
	[self dismissViewControllerAnimated:YES completion:NULL];
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
	
	if (![self inSearchMode]) {
		count++; //--include the all button;
	}
	
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0 && ![self inSearchMode]) {
		return 1;
	} else {
		NSInteger adjustedSection = [self inSearchMode] ? section : (section - 1);
		NSInteger rowCount = [[self selectionDataSource] locationCountInSection:adjustedSection];
		
		return rowCount;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *locationCell = [tableView dequeueReusableCellWithIdentifier:RPLocationSelectionViewControllerCellIdentifier];
	
	if (!locationCell) {
		locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RPLocationSelectionViewControllerCellIdentifier];
		locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	locationCell.textLabel.font = [UIFont rpk_boldFontWithSize:14.0f];
	
	if (indexPath.section == kLSVCSectionAll && ![self inSearchMode]) {
		locationCell.textLabel.text = @"All";
		locationCell.accessoryType = ([self isAllSelected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
	} else {
		NSInteger adjustedSection = ([self inSearchMode] ? indexPath.section : (indexPath.section - 1));
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:adjustedSection];
		RPSelection *selection = [[self selectionDataSource] locationAtIndexPath:adjustedIndexPath];
		locationCell.textLabel.text = selection.selectionLabel;
		locationCell.accessoryType = (selection.isSelected ?  UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
	}
	
	return locationCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == kLSVCSectionAll && ![self inSearchMode]) {
		[[self selectionDataSource] toggleSelectAll:![self isAllSelected]];
	} else {
		NSInteger adjustedSection = ([self inSearchMode] ? indexPath.section : (indexPath.section - 1));
		NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:adjustedSection];
		[[self selectionDataSource] toggleSelectionAtIndexPath:adjustedIndexPath];
	}
	
	[self.locationTableView.tableView reloadData];
	[self refreshNavigation];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return [[self selectionDataSource] indexTitles];
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
