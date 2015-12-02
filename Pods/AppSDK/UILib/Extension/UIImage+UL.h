//
//  UIImage+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UL)

+ (instancetype)ul_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (instancetype)ul_imageNamed:(NSString *)name;
+ (instancetype)ul_screenImageNamed:(NSString *)name;

- (instancetype)ul_tintedImageWithColor:(UIColor *)tintColor;
- (instancetype)ul_imageRotatedByDegrees:(CGFloat)degree;
- (instancetype)ul_grayScaleWithAlpha:(CGFloat)alpha;

@end
