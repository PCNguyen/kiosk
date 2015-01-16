//
//  UILabel+RP.h
//  Reputation
//
//  Created by PC Nguyen on 7/16/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (RP)

/**
 * Create and return the template label for timestamp
 * Use on upper right corner of feed cell
 * Or upper right corner of feed detail View
 *
 * @return preconfigured label
 */
+ (instancetype)rp_timeStampLabel;

/**
 * Create and return the template label for title
 *
 * @return preconfigured label
 */
+ (instancetype)rp_feedTitleLabel;

/**
 *  Create and return the template for author label
 *
 *  @return preconfigured label
 */
+ (instancetype)rp_authorLabel;

/**
 *  Create and return the template label for details
 *
 *  @return preconfigured label
 */
+ (instancetype)rp_detailLabel;

/**
 *  Create and return the template label for attributed text
 *
 *  @return preconfigured label
 */
+ (instancetype)rp_attributedLabel;

@end
