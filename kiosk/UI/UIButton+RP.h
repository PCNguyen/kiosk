//
//  UIButton+RP.h
//  Reputation
//
//  Created by PC Nguyen on 7/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kUIButtonImageSpacing = 10.0f;

@interface UIButton (RP)

+ (instancetype)rp_buttonWithIcon:(UIImage *)icon
							title:(NSAttributedString *)title
				  backgroundColor:(UIColor *)backgroundColor;

+ (instancetype)rp_blueButtonWithTitle:(NSString *)title;

@end
