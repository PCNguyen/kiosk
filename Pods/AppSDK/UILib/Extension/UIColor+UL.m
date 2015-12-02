//
//  UIColor+UL.m
//  AppSDK
//
//  Created by PC Nguyen on 5/15/14.
//  Copyright (c) 2014 PC Nguyen. All rights reserved.
//

#import "UIColor+UL.h"

@implementation UIColor (UL)

- (UIColor *)ul_darkenColorWithRatio:(CGFloat)ratio {
    CGFloat redColor = 0.0f;
	CGFloat greenColor = 0.0f;
	CGFloat blueColor = 0.0f;
	CGFloat alpha = 0.0f;
	
	[self getRed:&redColor green:&greenColor blue:&blueColor alpha:&alpha];
	
	redColor -= ratio / 255.0f;
	greenColor -= ratio / 255.0f;
	blueColor -= ratio / 255.0f;
	
	return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
}

- (UIColor *)ul_ligthenColorWithRatio:(CGFloat)ratio {
    CGFloat redColor = 0.0f;
	CGFloat greenColor = 0.0f;
	CGFloat blueColor = 0.0f;
	CGFloat alpha = 0.0f;
	
	[self getRed:&redColor green:&greenColor blue:&blueColor alpha:&alpha];
	
	redColor += ratio / 255.0f;
	greenColor += ratio / 255.0f;
	blueColor += ratio / 255.0f;
	
	return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:alpha];
}

+ (UIColor *)ul_colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)ul_colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self __colorComponentFrom: colorString start: 0 length: 1];
            green = [self __colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self __colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self __colorComponentFrom: colorString start: 0 length: 1];
            red   = [self __colorComponentFrom: colorString start: 1 length: 1];
            green = [self __colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self __colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self __colorComponentFrom: colorString start: 0 length: 2];
            green = [self __colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self __colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self __colorComponentFrom: colorString start: 0 length: 2];
            red   = [self __colorComponentFrom: colorString start: 2 length: 2];
            green = [self __colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self __colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

#pragma mark - Private

+ (CGFloat)__colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
}

@end
