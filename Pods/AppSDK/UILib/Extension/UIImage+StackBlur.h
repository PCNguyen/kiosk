//
//  UIImage+StackBlur.h
//  stackBlur
//
//  Created by Thomas LANDSPURG on 07/02/12.
//  Copyright 2012 Digiwie. All rights reserved.
//
// StackBlur implementation on iOS
//
//

#import <Foundation/Foundation.h>

@interface UIImage (StackBlur)

- (UIImage *)ul_stackBlur:(NSUInteger)radius;

- (UIImage *)ul_normalize;

+ (void)ul_applyStackBlurToBuffer:(UInt8 *)targetBuffer
							width:(const int)w
						   height:(const int)h
					   withRadius:(NSUInteger)inradius;
@end
