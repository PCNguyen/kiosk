//
//  RPKTableViewCell.h
//  Kiosk
//
//  Created by PC Nguyen on 1/26/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPKTableViewCell : UITableViewCell

/**
 *  A convenient index to idenfy the cell in one section table
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  A coneneient indexPath to identify the cell in multiple section table
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

/**
 *  Provide a paddings surround element in the view
 */
@property (nonatomic, assign) UIEdgeInsets paddings;

/**
 *  Provide the spacings vertical and horizontal
 */
@property (nonatomic, assign) CGSize spacings;

/**
 *  provide the view setup within this method,
 */
- (void)commonInit;

/**
 *  given a bound that take into account of paddings
 *
 *  @return the padding inset of the view bound
 */
- (CGRect)adjustedBounds;

/**
 *  convenient accessor to assign a whole cell model
 *
 *  @param model     the object model that the cell based on
 *  @param indexPath the indexPath to identify the cell
 */
- (void)assignModel:(id)model forIndexPath:(NSIndexPath *)indexPath;

@end
