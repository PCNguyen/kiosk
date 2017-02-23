//
//  UIView+Blur.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+StackBlur.h"

@interface UIView (Blur)

- (UIImage *)ul_screenShot;

- (void)ul_blur;

- (void)ul_clearBlur;

@end
