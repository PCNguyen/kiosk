//
//  NSAttributedString+RP.h
//  Reputation
//
//  Created by PC Nguyen on 7/17/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (RP)

+ (NSMutableAttributedString *)rp_attributedDescriptionFromText:(NSString *)descriptionText;
+ (NSMutableAttributedString *)rp_attributedSubratingTitle:(NSString *)subRatingTitle;

- (void)rp_addLineSpacing:(CGFloat)lineHeight;
- (void)rp_addLineSpacing:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
