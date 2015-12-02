//
//  UIBarButtonItem+UL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (UL)

+ (instancetype)ul_barButtonItemWithImage:(UIImage *)image
								   target:(id)target
								   action:(SEL)action;

@end
