//
//  ULTagTableViewController.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	TagTableViewCellTypeStandardText = 0,
	TagTableViewCellTypeSubText,
	TagTableViewCellTypeDisclosure,
	TagTableViewCellTypeAccessoryView,
	TagTableViewCellTypeSelection,
	TagTableViewCellTypeGroupSelection,
}
ULTagTableViewCellType;

#pragma mark - Required MetaData Keys

static NSString *const kCellType							= @"kCellType";
static NSString *const kCellIsVisible						= @"kCellIsVisible";
static NSString *const kRowIndex							= @"kRowIndex";
static NSString *const kSectionIndex						= @"kSectionIndex";
static NSString *const kCellText							= @"kCellText";

#pragma mark - Optional MetaData Keys

static NSString *const kCellTag								= @"kCellTag";
static NSString *const kCellDetailText						= @"kCellDetailText";
static NSString *const kCellSelectedAction					= @"kCellSelectedAction";
static NSString *const kCellAccessoryView					= @"kCellAccessoryView";
static NSString *const kCellIsSelected						= @"kCellIsSelected";
static NSString *const kCellIsGrouped						= @"kCellIsGrouped";

@interface ULTagTableViewController : UITableViewController

/**********************************************
 * NON OVERRIDING
 **********************************************/

#pragma mark - Create New Section

- (void)createNewSection;

#pragma mark - Create New Cell

- (void)createCellWithText:(NSString *)text
				detailText:(NSString *)detailText
					   tag:(NSNumber *)tag;

- (void)createCellWithText:(NSString *)text
			 subDetailText:(NSString *)detailText
					   tag:(NSNumber *)tag;

- (void)createCellWithText:(NSString *)text
				detailText:(NSString *)detailText
		  disclosureAction:(SEL)selectedAction
					   tag:(NSNumber *)tag;

- (void)createCellWithText:(NSString *)text
			 accessoryView:(UIView *)accessoryView
					   tag:(NSNumber *)tag;

- (void)createSelectionCellWithText:(NSString *)text
                             action:(SEL)selectedAction
                    defaultSelected:(BOOL)isSelected
                                tag:(NSNumber *)tag;

- (void)createGroupSelectionCellWithText:(NSString *)text
                                  action:(SEL)selectedAction
                         defaultSelected:(BOOL)isSelected
                                     tag:(NSNumber *)tag;

#pragma mark - Show / Hide Cell

- (void)hideBeforeLoadForCellWithTag:(NSInteger)tag;
- (void)toggleVisibilityForCellAtIndexPath:(NSIndexPath *)indexPath isVisible:(BOOL)isVisible;
- (void)toggleVisibilityForCellWithTag:(NSInteger)tag isVisible:(BOOL)isVisible;

#pragma mark - Programatic Select Cell

- (void)selectCellWithTag:(NSInteger)tag;

#pragma mark - Index Mapping

- (NSDictionary *)cellInfoFromTag:(NSInteger)tag;
- (NSDictionary *)cellInfoForVisibleIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathFromCellInfo:(NSDictionary *)cellInfo;

#pragma mark - Group Cell Creation

- (void)createGroupSelectionCellsFromArray:(NSArray *)selectionTitles
									action:(SEL)selectedAction
							 selectedIndex:(NSInteger)index
									   tag:(NSNumber *)tag;

- (void)createSelectionCellsFromArray:(NSArray *)selectionTitles
							   action:(SEL)selectedAction
						selectedIndex:(NSArray *)indexArray
								  tag:(NSNumber *)tag;

#pragma mark - Show / Hide Group Cell

- (void)hideBeforeLoadForCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag;
- (void)toggleVisibilityForCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag isVisible:(BOOL)visible;

#pragma mark - Selection

- (void)selectAllCellsInGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag isSelected:(BOOL)isSelected;
- (NSArray *)selectedItemsInCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag;
- (NSArray *)selectedIndexInCellGroup:(NSArray *)selectionTitles withTag:(NSInteger)tag;

/********************* END NON-OVERRIDING METHODS ****************************/

#pragma mark - Public Actions

- (void)deselectAllGroupSelectionCellExceptCellInfo:(NSDictionary *)cellInfo;
- (NSDictionary *)updateAttribute:(NSString *)attributeKey withNewValue:(id)value forCellInfo:(NSDictionary *)cellInfo;

#pragma mark - Refresh

- (void)refreshTableData;
- (void)refreshRowWithTag:(NSInteger)tag;
- (void)refreshSectionContainCellInfo:(NSDictionary *)cellInfo;

#pragma mark - Reset

- (void)clearAllTableContent;

#pragma mark - Sub class Hook

- (void)formatAdditionalAttributeForCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)formatAdditionalAttributeForCell:(UITableViewCell *)cell withTag:(NSInteger)tag;

#pragma mark - Class Helper

+ (CGRect)settingAccessoryFrame;

@end

