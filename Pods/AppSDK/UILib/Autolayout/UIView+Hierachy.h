//
//  UIView+Hierachy.h
//  AppSDK
//
//  Created by PC Nguyen on 8/22/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Hierachy)

- (UIView *)ul_nearestCommonAncestorToView:(UIView *)view;

@end
