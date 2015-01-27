//
//  RPLocationDataSource.h
//  Reputation
//
//  Created by PC Nguyen on 6/9/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPPreferenceDataSource.h"
#import "RPService.h"
#import "RPKLocationSelection.h"

@interface RPLocationSelectionDataSource : RPPreferenceDataSource

/**
 *  Data Structure for formatting an indexed list.
 *	Key is the indexed alphabet
 *	Values is an array of locations that start with that alphabet letter
 */
@property (nonatomic, strong) NSDictionary *locations;

/**
 *  Whether or not we want only locations with social sites enable for post
 *	If this is set to NO, we return a list of all locations
 *	Default is NO
 */
@property (nonatomic, assign) BOOL hasSocialSitesEnable;

#pragma mark - UI Helper

/**
 *  Number of sections to indexed with
 *
 *  @return number of sections
 */
- (NSInteger)sectionCount;

/**
 *  Number of selections for each section
 *
 *  @param section the section in the list view
 *
 *  @return number of selections for this particular section
 */
- (NSInteger)locationCountInSection:(NSInteger)section;

/**
 *  return the selection to format the list at a particular indexPath
 *
 *  @param indexPath indexPath of the list
 *
 *  @return an RPSelection object
 */
- (RPKLocationSelection *)locationAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Index

/**
 *  The initial titles to show on the right hand side
 *
 *  @return array of alphabetical presentation of each section.
 */
- (NSArray *)indexTitles;

#pragma mark - Search

/**
 *  Filter the list with filter text
 *
 *  @param filterText the text to filter the list
 */
- (void)applyFilterText:(NSString *)filterText;

#pragma mark - Selection

/**
 *  Access a copy of all locations
 *
 *  @return array of RPSelection objects
 */
- (NSMutableArray *)allLocations;

/**
 *  Access all selected location code
 *
 *  @return array of NSString presentation of selected location codes
 */
- (NSMutableArray *)selectedLocations;

/**
 *  Mark all selection selected or unSelected
 *
 *  @param isSelected selected or not
 */
- (void)toggleSelectAll:(BOOL)isSelected;

/**
 *  Mark a location selected or unSelected
 *
 *  @param indexPath  the indexPath of the selection
 */
- (void)toggleSelectionAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Option to pass in a preselected Values Set,
 *	Effect disable if applyUserSettings is set to YES
 *
 *  @param selectedIDs array of NSString presentation of selectedIDs
 */
- (void)applyPreselections:(NSArray *)selectedIDs;

/**
 *  Actual save the selected location to disk
 */
- (void)persistSelectedLocation;

@end
