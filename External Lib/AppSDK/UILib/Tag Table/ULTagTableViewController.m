//
//  ULTagTableViewController.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "ULTagTableViewController.h"

#import "NSObject+AL.h"

//--cell reuse identifiers
static NSString *const kDefaultLabelCellIdentifier			= @"kDefaultLabelCellIdentifier";
static NSString *const kSubTextlabelCellIdentifier			= @"kSubTextlabelCellIdentifier";
static NSString *const kDisclosureActionCellIdentifier		= @"kDisclosureActionCellIdentifier";
static NSString *const kAccessoryViewCellIdentifier			= @"kAccessoryViewCellIdentifier";
static NSString *const kSelectionCellIdentifier				= @"kSelectionCellIdentifier";
static NSString *const kGroupSelectionCellIdentifier		= @"kGroupSelectionCellIdentifier";

static NSInteger const kDefaultCellTag						= -1;

@interface ULTagTableViewController ()

@property (nonatomic, strong) NSMutableArray *cellList;
@property (nonatomic, assign) NSInteger nextAvailableSectionIdex;
@property (nonatomic, assign) NSInteger nextAvailableRowIndex;

@end

@implementation ULTagTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
	if (self) {
        _cellList = [[NSMutableArray alloc] init];
		_nextAvailableSectionIdex = 0;
		_nextAvailableRowIndex = 0;
    }
	
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSectionFromCellList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *cellInfo = [self cellInfoForVisibleIndexPath:indexPath];
	
	UITableViewCell *cell = nil;
	
	ULTagTableViewCellType cellType = (ULTagTableViewCellType)[[cellInfo valueForKey:kCellType] integerValue];
	
	switch (cellType) {
            
		case TagTableViewCellTypeStandardText:
			cell = [self defaultLabelCellWithInfo:cellInfo];
			break;
            
		case TagTableViewCellTypeSubText:
			cell = [self subTextLabelCellWithInfo:cellInfo];
			break;
            
		case TagTableViewCellTypeDisclosure:
			cell = [self disclosureActionCellWithInfo:cellInfo];
			break;
            
		case TagTableViewCellTypeAccessoryView:
			cell = [self accessoryViewCellWithInfo:cellInfo];
			break;
            
		case TagTableViewCellTypeSelection:
			cell = [self selectionCellWithInfo:cellInfo];
			break;
			
		case TagTableViewCellTypeGroupSelection:
			cell = [self groupSelectionCellWithInfo:cellInfo];
			break;
            
		default:
			NSAssert(NO, @"Unsupported Cell Type Found");
			break;
	}
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *cellInfo = [self cellInfoForVisibleIndexPath:indexPath];
	ULTagTableViewCellType cellType = (ULTagTableViewCellType)[[cellInfo valueForKey:kCellType] integerValue];
	
	switch (cellType) {
		case TagTableViewCellTypeDisclosure: {
			[self performActionBasedOnCellInfo:cellInfo];
		} break;
			
		case TagTableViewCellTypeGroupSelection: {
			NSDictionary *groupSelectionCellInfo = [self cellInfoForVisibleIndexPath:indexPath];
			groupSelectionCellInfo = [self updateAttribute:kCellIsSelected withNewValue:[NSNumber numberWithBool:YES] forCellInfo:groupSelectionCellInfo];
			[self deselectAllGroupSelectionCellExceptCellInfo:groupSelectionCellInfo];
			[self refreshSectionContainCellInfo:groupSelectionCellInfo];
			[self performActionBasedOnCellInfo:groupSelectionCellInfo];
		} break;
            
		case TagTableViewCellTypeSelection: {
			NSDictionary *selectionCellInfo = [self cellInfoForVisibleIndexPath:indexPath];
			
			//--reverse selection
			NSNumber *isSelected = [NSNumber numberWithBool:![[selectionCellInfo valueForKey:kCellIsSelected] boolValue]];
			selectionCellInfo = [self updateAttribute:kCellIsSelected withNewValue:isSelected forCellInfo:selectionCellInfo];
			
			[self refreshSectionContainCellInfo:selectionCellInfo];
			[self performActionBasedOnCellInfo:selectionCellInfo];
		} break;
			
		default:
			break;
	}
}

#pragma mark - Table DataSource Helpers

- (NSInteger)numberOfSectionFromCellList {
	NSMutableSet *sectionSet = [NSMutableSet set];
	
	for (NSDictionary *cellInfo in self.cellList) {
		[sectionSet addObject:[cellInfo valueForKey:kSectionIndex]];
	}
	
	NSInteger sectionFound = [sectionSet count];
	
	//--defensive
	if (sectionFound != self.nextAvailableSectionIdex) {
		assert(@"Inconsistency data structure");
	}
	
	return sectionFound;
}

- (NSInteger)numberOfRowInSection:(NSInteger)sectionIndex {
	NSInteger count = 0;
	
	for (NSDictionary *cellInfo in self.cellList) {
		
		BOOL isVisible = [[cellInfo valueForKey:kCellIsVisible] boolValue];
		BOOL inSection = ([[cellInfo valueForKey:kSectionIndex] integerValue] == sectionIndex);
		
		if (inSection && isVisible) {
			count++;
		}
	}
	
	return count;
}

- (NSDictionary *)cellInfoAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *returnedCellInfo = nil;
	
	for (NSDictionary *cellInfo in self.cellList) {
		if ([[cellInfo objectForKey:kSectionIndex] integerValue] == indexPath.section
			&& [[cellInfo objectForKey:kRowIndex] integerValue] == indexPath.row) {
			returnedCellInfo = cellInfo;
		}
	}
	
	return returnedCellInfo;
}

- (NSDictionary *)cellInfoForVisibleIndexPath:(NSIndexPath *)indexPath {
	NSInteger rowIndex = indexPath.row;
	NSInteger sectionIndex = indexPath.section;
    
    NSInteger visibleRowCount = 0;
	NSInteger rowAdjustment = 0;
	
	for (NSDictionary *cellInfo in self.cellList) {
		
		BOOL sameSection = ([[cellInfo objectForKey:kSectionIndex] integerValue] == sectionIndex);
        
        if (sameSection) {
            
            BOOL isVisible = [[cellInfo objectForKey:kCellIsVisible] boolValue];
            
            if (isVisible) {
                visibleRowCount++;
            } else {
                rowAdjustment++;
            }
        }
        
        if (visibleRowCount > rowIndex) {
            break;
        }
        
	}
	
    rowIndex = rowIndex + rowAdjustment;
	NSIndexPath *adjustedIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
	
	return [self cellInfoAtIndexPath:adjustedIndexPath];
}

- (NSDictionary *)cellInfoFromTag:(NSInteger)tag {
	NSDictionary *returnedCellInfo = nil;
	
	for (NSDictionary *cellInfo in self.cellList) {
		if ([[cellInfo objectForKey:kCellTag] integerValue] == tag) {
			returnedCellInfo = cellInfo;
		}
	}
	
	return returnedCellInfo;
}

- (NSIndexPath *)indexPathFromCellInfo:(NSDictionary *)cellInfo {
	NSIndexPath *returnedIndexPath = nil;
	
	NSInteger row = [[cellInfo valueForKey:kRowIndex] integerValue];
	NSInteger section = [[cellInfo valueForKey:kSectionIndex] integerValue];
    
	returnedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
	
	return returnedIndexPath;
}

- (NSIndexPath *)indexPathAdjustedFromCellInfo:(NSDictionary *)cellInfo {
    NSIndexPath *returnedIndexPath = nil;
	
	NSInteger row = [[cellInfo valueForKey:kRowIndex] integerValue];
	NSInteger section = [[cellInfo valueForKey:kSectionIndex] integerValue];
    NSInteger rowAdjustment = 0;
    
    for (NSDictionary *searchCellInfo in self.cellList) {
        BOOL sameSection = ([[searchCellInfo objectForKey:kSectionIndex] integerValue] == section);
        BOOL aboveCurrentRow = ([[searchCellInfo objectForKey:kRowIndex] integerValue] < row);
        BOOL visible = ([[searchCellInfo objectForKey:kCellIsVisible] boolValue]);
        
        if (sameSection && aboveCurrentRow && !visible) {
            rowAdjustment++;
        }
    }
    
    row = row - rowAdjustment;
	returnedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
	
	return returnedIndexPath;
}

- (void)refreshSectionContainCellInfo:(NSDictionary *)cellInfo {
	NSInteger section = [[cellInfo valueForKey:kSectionIndex] integerValue];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section]
				  withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Puclic Section Creation

- (void)createNewSection {
	[self increaseSectionCount];
}

#pragma mark - Public Cell Creation

- (void)createCellWithText:(NSString *)text detailText:(NSString *)detailText tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
	
	[cellInfo setValue:detailText forKey:kCellDetailText];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeStandardText] forKey:kCellType];
	
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	[self increaseRowCount];
}

- (void)createCellWithText:(NSString *)text subDetailText:(NSString *)detailText tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
    
	[cellInfo setValue:detailText forKey:kCellDetailText];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeSubText] forKey:kCellType];
	
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	[self increaseRowCount];
}

- (void)createCellWithText:(NSString *)text detailText:(NSString *)detailText disclosureAction:(SEL)selectedAction tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
	
    [cellInfo setValue:detailText forKey:kCellDetailText];
	[cellInfo setValue:[NSValue valueWithPointer:selectedAction] forKey:kCellSelectedAction];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeDisclosure] forKey:kCellType];
	
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	[self increaseRowCount];
}

- (void)createCellWithText:(NSString *)text accessoryView:(UIView *)accessoryView tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
	
	[cellInfo setValue:accessoryView forKey:kCellAccessoryView];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeAccessoryView] forKey:kCellType];
	
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	[self increaseRowCount];
}

- (void)createSelectionCellWithText:(NSString *)text action:(SEL)selectedAction defaultSelected:(BOOL)isSelected tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
	
	[cellInfo setValue:[NSValue valueWithPointer:selectedAction] forKey:kCellSelectedAction];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeSelection] forKey:kCellType];
	[cellInfo setValue:[NSNumber numberWithBool:isSelected] forKey:kCellIsSelected];
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	[self increaseRowCount];
}

- (void)createGroupSelectionCellWithText:(NSString *)text action:(SEL)selectedAction defaultSelected:(BOOL)isSelected tag:(NSNumber *)tag {
	NSMutableDictionary *cellInfo = [NSMutableDictionary dictionary];
	
	[cellInfo setValue:[NSValue valueWithPointer:selectedAction] forKey:kCellSelectedAction];
	[cellInfo setValue:[NSNumber numberWithInt:TagTableViewCellTypeGroupSelection] forKey:kCellType];
	[cellInfo setValue:[NSNumber numberWithBool:isSelected] forKey:kCellIsSelected];
	[self insertCellInfo:cellInfo withCellText:text tag:tag];
	
	if (isSelected) {
		[self deselectAllGroupSelectionCellExceptCellInfo:cellInfo];
	}
	
	[self increaseRowCount];
}

#pragma mark - Public For Subclass Usage

- (void)deselectAllGroupSelectionCellExceptCellInfo:(NSDictionary *)cellInfo {
	NSInteger section = [[cellInfo valueForKey:kSectionIndex] integerValue];
	NSInteger row = [[cellInfo valueForKey:kRowIndex] integerValue];
	
	//--since we cannot update the info directly while itterate through the cell list
	NSMutableArray *updatedCellInfos = [NSMutableArray array];
	
	for (NSDictionary *searchCellInfo in self.cellList) {
		BOOL sameSection = ([[searchCellInfo valueForKey:kSectionIndex] integerValue] == section);
		BOOL differentRow = ([[searchCellInfo valueForKey:kRowIndex] integerValue] != row);
		if (sameSection && differentRow) {
			[updatedCellInfos addObject:searchCellInfo];
		}
	}
	
	for (NSDictionary *updatedInfo in updatedCellInfos) {
		[self updateAttribute:kCellIsSelected withNewValue:[NSNumber numberWithBool:NO] forCellInfo:updatedInfo];
	}
}

#pragma mark - Public Table Handling

- (void)clearAllTableContent {
    [self.cellList removeAllObjects];
    self.nextAvailableSectionIdex = 0;
    self.nextAvailableRowIndex = 0;
}

- (void)refreshTableData {
    [self.tableView reloadData];
}

- (void)refreshRowWithTag:(NSInteger)tag {
    NSDictionary *cellInfo = [self cellInfoFromTag:tag];
    NSIndexPath *indexPath = [self indexPathAdjustedFromCellInfo:cellInfo];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Cell Modifiying

- (void)toggleVisibilityForCellAtIndexPath:(NSIndexPath *)indexPath isVisible:(BOOL)isVisible
{
	NSDictionary *cellInfo = [self cellInfoAtIndexPath:indexPath];
	BOOL isCurrentlyVisible = [[cellInfo objectForKey:kCellIsVisible] boolValue];
	
	if (isCurrentlyVisible != isVisible) {
		
		//--update cell info dictionary
		cellInfo = [self updateAttribute:kCellIsVisible withNewValue:[NSNumber numberWithBool:isVisible] forCellInfo:cellInfo];
		
        NSIndexPath *modifiedIndexPath = [self indexPathAdjustedFromCellInfo:cellInfo];
        
		//--update the table view
		[self.tableView beginUpdates];
		
		if (isVisible) {
			//--insert the cell
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:modifiedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		} else {
			//--delete the cell
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:modifiedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
		
		[self.tableView endUpdates];
	}
}

- (void)toggleVisibilityForCellWithTag:(NSInteger)tag isVisible:(BOOL)isVisible {
	NSDictionary *cellInfo = [self cellInfoFromTag:tag];
	NSIndexPath *indexPath = [self indexPathFromCellInfo:cellInfo];
	
	[self toggleVisibilityForCellAtIndexPath:indexPath isVisible:isVisible];
}

- (void)updateCellInfo:(NSDictionary *)cellInfo withModifiedCellInfo:(NSMutableDictionary *)modifiedCellInfo {
	NSInteger modifiedIndex = [self.cellList indexOfObject:cellInfo];
	
	if (modifiedIndex >= 0) {
		[self.cellList replaceObjectAtIndex:modifiedIndex withObject:modifiedCellInfo];
	} else {
		
	}
    
}

- (NSDictionary *)updateAttribute:(NSString *)attributeKey withNewValue:(id)value forCellInfo:(NSDictionary *)cellInfo {
	NSMutableDictionary *modifiedCellInfo = [cellInfo mutableCopy];
	[modifiedCellInfo setValue:value forKey:attributeKey];
	[self updateCellInfo:cellInfo withModifiedCellInfo:modifiedCellInfo];
	
	return modifiedCellInfo;
}

- (void)hideBeforeLoadForCellWithTag:(NSInteger)tag {
    NSDictionary *cellInfo = [self cellInfoFromTag:tag];
    [self updateAttribute:kCellIsVisible withNewValue:[NSNumber numberWithBool:NO] forCellInfo:cellInfo];
}

#pragma mark - Cell Selection

- (void)selectCellWithTag:(NSInteger)tag {
	NSDictionary *cellInfo = [self cellInfoFromTag:tag];
	NSIndexPath *selectedIndexPath = [self indexPathFromCellInfo:cellInfo];
	[self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
}

#pragma mark - Cell Configuration

- (UITableViewCell *)defaultLabelCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDefaultLabelCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									  reuseIdentifier:kDefaultLabelCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
	cell.detailTextLabel.text = [cellInfo valueForKey:kCellDetailText];
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

- (UITableViewCell *)subTextLabelCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSubTextlabelCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:kSubTextlabelCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
	cell.detailTextLabel.text = [cellInfo valueForKey:kCellDetailText];
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

- (UITableViewCell *)disclosureActionCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDisclosureActionCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									  reuseIdentifier:kDisclosureActionCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
    cell.detailTextLabel.text = [cellInfo valueForKey:kCellDetailText];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

- (UITableViewCell *)accessoryViewCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kAccessoryViewCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:kAccessoryViewCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
	cell.accessoryView = [cellInfo valueForKey:kCellAccessoryView];
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

- (UITableViewCell *)selectionCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSelectionCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									  reuseIdentifier:kSelectionCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
	
	BOOL isCurrentlySelected = [[cellInfo valueForKey:kCellIsSelected] boolValue];
	
	if (isCurrentlySelected) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

- (UITableViewCell *)groupSelectionCellWithInfo:(NSDictionary *)cellInfo {
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kGroupSelectionCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
									  reuseIdentifier:kGroupSelectionCellIdentifier];
		[self formatDefaultAttributeForCell:cell];
	}
	
	cell.textLabel.text = [cellInfo valueForKey:kCellText];
	
	BOOL isCurrentlySelected = [[cellInfo valueForKey:kCellIsSelected] boolValue];
	
	if (isCurrentlySelected) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[self formatAdditionalAttributeForCell:cell withCellInfo:cellInfo];
	
	return cell;
}

#pragma mark - Cell Formatter

- (void)formatDefaultAttributeForCell:(UITableViewCell *)cell {
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
}

- (void)formatAdditionalAttributeForCell:(UITableViewCell *)cell withCellInfo:(NSDictionary *)cellInfo {
	NSIndexPath *mappedIndexPath = [self indexPathFromCellInfo:cellInfo];
	[self formatAdditionalAttributeForCell:cell atIndexPath:mappedIndexPath];
    
    NSNumber *tag = [cellInfo valueForKey:kCellTag];
    
    if (tag) {
        [self formatAdditionalAttributeForCell:cell withTag:[tag integerValue]];
    }
}

- (void)formatAdditionalAttributeForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	//--override by subclass to add addition cell format
}

- (void)formatAdditionalAttributeForCell:(UITableViewCell *)cell withTag:(NSInteger)tag {
    //--override by subclass to add addition cell format
}

#pragma mark - Group Cell Creation

- (void)createGroupSelectionCellsFromArray:(NSArray *)selectionTitles
									action:(SEL)selectedAction
							 selectedIndex:(NSInteger)index
									   tag:(NSNumber *)tag
{
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:[tag integerValue]];
		BOOL defaultSelected = (titleIndex == index);
		
		[self createGroupSelectionCellWithText:title
										action:selectedAction
							   defaultSelected:defaultSelected
										   tag:@(mappedTag)];
	}];
}

- (void)createSelectionCellsFromArray:(NSArray *)selectionTitles
							   action:(SEL)selectedAction
						selectedIndex:(NSArray *)indexArray
								  tag:(NSNumber *)tag
{
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:[tag integerValue]];
		BOOL defaultSelected = [indexArray containsObject:@(titleIndex)];
		
		[self createSelectionCellWithText:title
								   action:selectedAction
						  defaultSelected:defaultSelected
									  tag:@(mappedTag)];
	}];
}

#pragma mark - Show / Hide Group Cell

- (void)hideBeforeLoadForCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag
{
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:tag];
		[self hideBeforeLoadForCellWithTag:mappedTag];
	}];
}

- (void)toggleVisibilityForCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag isVisible:(BOOL)visible
{
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:tag];
		
		NSDictionary *cellInfo = [self cellInfoFromTag:mappedTag];
		BOOL isCurrentlyVisible = [[cellInfo objectForKey:kCellIsVisible] boolValue];
		
		if (isCurrentlyVisible != visible) {
			
			//--update cell info dictionary
			[self updateAttribute:kCellIsVisible withNewValue:[NSNumber numberWithBool:visible] forCellInfo:cellInfo];
		}
	}];
	
	[self refreshTableData];
}

#pragma mark - Selection

- (void)selectAllCellsInGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag isSelected:(BOOL)isSelected
{
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:tag];
		NSDictionary *cellInfo = [self cellInfoFromTag:mappedTag];
		BOOL isCurrentSelected = [[cellInfo valueForKey:kCellIsSelected] boolValue];
		
		if (isSelected != isCurrentSelected) {
			[self updateAttribute:kCellIsSelected withNewValue:@(isSelected) forCellInfo:cellInfo];
		}
	}];
	
	[self.tableView reloadData];
}

- (NSArray *)selectedItemsInCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag
{
	NSMutableArray *selectedTitles = [NSMutableArray array];
	
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:tag];
		NSDictionary *cellInfo = [self cellInfoFromTag:mappedTag];
		BOOL isCurrentSelected = [[cellInfo valueForKey:kCellIsSelected] boolValue];
		
		if (isCurrentSelected) {
			[selectedTitles addObject:title];
		}
	}];
	
	return selectedTitles;
}

- (NSArray *)selectedIndexInCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag
{
	NSMutableArray *selectedTitlesIndex = [NSMutableArray array];
	
	[selectionTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger titleIndex, BOOL *stop) {
		NSInteger mappedTag = [self mappedTagForIndex:titleIndex fromGroupTag:tag];
		NSDictionary *cellInfo = [self cellInfoFromTag:mappedTag];
		BOOL isCurrentSelected = [[cellInfo valueForKey:kCellIsSelected] boolValue];
		
		if (isCurrentSelected) {
			[selectedTitlesIndex addObject:@(titleIndex)];
		}
	}];
	
	return selectedTitlesIndex;
}

#pragma mark - Private

- (void)increaseSectionCount {
	self.nextAvailableSectionIdex++;
	self.nextAvailableRowIndex = 0;
}

- (void)increaseRowCount {
	self.nextAvailableRowIndex++;
}

- (void)insertCellInfo:(NSMutableDictionary *)cellInfo withCellText:(NSString *)text tag:(NSNumber *)tag {
	//--adding some default attribute
	[cellInfo setValue:[NSNumber numberWithBool:YES] forKey:kCellIsVisible];
	[cellInfo setValue:[NSNumber numberWithInteger:self.nextAvailableSectionIdex] forKey:kSectionIndex];
	[cellInfo setValue:[NSNumber numberWithInteger:self.nextAvailableRowIndex] forKey:kRowIndex];
	[cellInfo setValue:text forKey:kCellText];
	
	if (tag) {
		[cellInfo setValue:tag forKey:kCellTag];
	} else {
		[cellInfo setValue:[NSNumber numberWithInt:kDefaultCellTag] forKey:kCellTag];
	}
	
	[self.cellList addObject:cellInfo];
}

- (void)performActionBasedOnCellInfo:(NSDictionary *)cellInfo {
	SEL selectionPerformed = [[cellInfo valueForKey:kCellSelectedAction] pointerValue];
	
	if (selectionPerformed) {
		[self al_performSelector:selectionPerformed withObject:cellInfo];
	}
    
}

- (NSInteger)mappedTagForIndex:(NSUInteger)index fromGroupTag:(NSInteger)tag
{
	NSInteger collisionFactor = -1;
	NSInteger steps = 100; //--TODO:make this dynamic based on the array size
	
	NSInteger mappedTag = (tag * steps + index) * collisionFactor;
	
	return mappedTag;
}

#pragma mark - Class Helper

+ (CGRect)settingAccessoryFrame
{
    CGRect frame = CGRectMake(0.0f, 0.0f, 95.0f, 27.0f);
    return frame;
}

@end
