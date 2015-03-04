//
//  RPLocationDataSource.m
//  Reputation
//
//  Created by PC Nguyen on 6/9/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPLocationSelectionDataSource.h"
#import "RPKUIKit.h"
#import "MobileCommon.h"

#import <AppSDK/AppLibExtension.h>

@interface RPLocationSelectionDataSource ()

@property (nonatomic, strong) NSArray *indexTitles;
@property (nonatomic, strong) NSString *filter;
@property (nonatomic, strong) NSMutableArray *selectedLocations;

@end

@implementation RPLocationSelectionDataSource

#pragma mark - ULManagedDataSource Override

- (void)configureNonBindingProperty
{
	[super configureNonBindingProperty];
	
	[self ignoreUpdateProperty:@selector(indexTitles)];
	[self ignoreUpdateProperty:@selector(filter)];
	[self ignoreUpdateProperty:@selector(selectedLocations)];
	[self ignoreUpdateProperty:@selector(hasSocialSitesEnable)];
}

- (void)loadData
{
	NSString *selectedLocation = [self.preferenceStorage loadSelectedLocation];
	if ([selectedLocation length] > 0) {
		[self applyPreselections:@[selectedLocation]];
	}
	
	self.locations = [self parseLocationSelections];
}

#pragma mark - Parsing

- (NSMutableDictionary *)parseLocationSelections
{
	NSArray *locations = [self userConfig].authLocations;
	
	if ([self.filter length] > 0) {
		NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", self.filter];
		locations = [locations filteredArrayUsingPredicate:filterPredicate];
	}
	
	NSMutableDictionary *selectionDictionary = [NSMutableDictionary dictionary];
	
	//--group
	for (Location *location in locations) {
		
		if ([self shouldParseLocation:location]) {
			RPKLocationSelection *selection = [RPKLocationSelection new];
			selection.selectionID = location.code;
			selection.selectionLabel = location.name;
			selection.selected = [self.selectedLocations containsObject:selection.selectionID];
			selection.enabledSources = LocationSourceNone;
			
			if ([location.kioskUrl length] > 0) {
				selection.enabledSources |= LocationSourceKiosk;
			}
			
			if ([location.sourceUrls count] > 0) {
				for (SourceUrl *sourceUrl in location.sourceUrls) {
					// Check for Google Plus/Places sources before enabling Google functionality.
					if([sourceUrl.source  isEqual: [MobileCommonConstants SOURCE_GOOGLE_PLACES]]) {
						selection.enabledSources |= LocationSourceGoogle;
					}

					// Check for the Cars.com source before enabling cars.com functionality.
					if([sourceUrl.source  isEqual: [MobileCommonConstants SOURCE_CARS]]) {
						selection.enabledSources |= LocationSourceCars;
					}
				}
			}
		
			//--retrieve the section this location belong to, if not, create new
			NSString *indexKey = [self indexLabelForName:location.name];
			NSMutableArray *indexSelections = [selectionDictionary valueForKey:indexKey];
			if (!indexSelections) {
				indexSelections = [NSMutableArray array];
				[selectionDictionary setValue:indexSelections forKey:indexKey];
			}
			
			[indexSelections addObject:selection];
		}
	}
	
	//--sort
	NSArray *sortedKey = [[selectionDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
	self.indexTitles = sortedKey;
	
	return selectionDictionary;
}

- (BOOL)shouldParseLocation:(Location *)location
{
	BOOL shouldParse = YES;
	
	if (self.hasSocialSitesEnable && [location.socialSitesPostEnabled count] == 0) {
		shouldParse = NO;
	}
	
	return shouldParse;
}

#pragma mark - UI Helper

- (NSInteger)sectionCount
{
	NSInteger count = [[self.locations allKeys] count];
	return count;
}

- (NSInteger)locationCountInSection:(NSInteger)section
{
	NSArray *indexLocations = [self.locations valueForKey:[self indexLabelForSection:section]];
	NSInteger count = [indexLocations count];
	return count;
}

- (RPKLocationSelection *)locationAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *indexLocations = [self.locations valueForKey:[self indexLabelForSection:indexPath.section]];
	RPKLocationSelection *location = [indexLocations al_objectAtIndex:indexPath.row];
	return location;
}

#pragma mark - Search

- (void)applyFilterText:(NSString *)filterText
{
	self.filter = filterText;
	self.locations = [self parseLocationSelections];
}

#pragma mark - Index

- (NSString *)indexLabelForName:(NSString *)name
{
	NSString *indexLabel = @"";
	
	if ([name length] > 0) {
		indexLabel = [[name substringToIndex:1] uppercaseString];
	}
	
	return indexLabel;
}

- (NSString *)indexLabelForSection:(NSInteger)section
{
	return [self.indexTitles al_objectAtIndex:section];
}

#pragma mark - Selection

- (NSMutableArray *)allLocations
{
	NSMutableArray *allLocations = [NSMutableArray array];
	
	[self.locations enumerateKeysAndObjectsUsingBlock:^(NSString *title, NSArray *locations, BOOL *stop) {
		[allLocations addObjectsFromArray:locations];
	}];
	
	return allLocations;
}

- (NSMutableArray *)selectedLocations
{
	if (!_selectedLocations) {
		_selectedLocations = [NSMutableArray array];
	}
	
	return _selectedLocations;
}

- (void)toggleSelectAll:(BOOL)isSelected
{
	[[self allLocations] enumerateObjectsUsingBlock:^(RPKSelection *selection, NSUInteger index, BOOL *stop) {
		selection.selected = isSelected;
		[self updateSelectedLocations:selection];
	}];
}

- (void)toggleSelectionAtIndexPath:(NSIndexPath *)indexPath
{
	RPKSelection *selection = [self locationAtIndexPath:indexPath];
	selection.selected = !selection.isSelected;
	[self updateSelectedLocations:selection];
}

- (void)applyPreselections:(NSArray *)selectedIDs
{
	self.selectedLocations = [NSMutableArray arrayWithArray:selectedIDs];
}

- (void)updateSelectedLocations:(RPKSelection *)selection
{
	if (selection.isSelected) {
		if (![self.selectedLocations containsObject:selection.selectionID]) {
			[self.selectedLocations addObject:selection.selectionID];
		}
	} else {
		[self.selectedLocations removeObject:selection.selectionID];
	}
}

- (void)persistSelectedLocation
{
	[self.preferenceStorage saveSelectedLocation:[self.selectedLocations al_objectAtIndex:0]];
	[[ULDataSourceManager sharedManager] notifyDataSourcesOfService:[RPService serviceNameFromType:ServiceUpdateSelectedLocation] error:nil];
}

- (Location *)locationForCode:(NSString *)code
{
	NSMutableArray *authLocations = [self userConfig].authLocations;
	
	for (Location *location in authLocations) {
		if ([location.code isEqualToString:code]) {
			return location;
		}
	}
	
	return nil;
}

@end
