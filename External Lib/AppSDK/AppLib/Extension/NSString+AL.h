//
//  NSString+AL.h
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (AL)

- (NSRange)al_fullRange;

- (NSMutableAttributedString *)al_attributedStringWithFont:(UIFont *)font
												 textColor:(UIColor *)color;

@end
