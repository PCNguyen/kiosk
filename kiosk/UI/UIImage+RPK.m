//
//  UIImage+RPK.m
//  kiosk
//
//  Created by PC Nguyen on 12/16/14.
//  Copyright (c) 2014 Reputation. All rights reserved.
//

#import "UIImage+RPK.h"

@implementation UIImage (RPK)

+ (instancetype)rpk_bundleImageNamed:(NSString *)imageName
{
	return [self ul_imageNamed:imageName];
}

@end
