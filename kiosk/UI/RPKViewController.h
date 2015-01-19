//
//  RPKViewController.h
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPKUIKit.h"
#import <PQFCustomLoaders/PQFCustomLoaders.h>

@interface RPKViewController : UIViewController

/**
*  Provide a paddings surround element in the view
*/
@property (nonatomic, assign) UIEdgeInsets paddings;

/**
*  Provide the spacings vertical and horizontal
*/
@property (nonatomic, assign) CGSize spacings;

- (void)toggleLoadingView:(BOOL)isVisible;

@end
