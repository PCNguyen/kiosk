//
//  RPKView.h
//  kiosk
//
//  Created by PC Nguyen on 1/7/15.
//  Copyright (c) 2015 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPKUIKit.h"

@interface RPKView : UIView

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

@end
