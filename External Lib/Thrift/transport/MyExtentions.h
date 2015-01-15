//
//  MyExtentions.h
//  AlokTest
//
//  Created by Alok Damireddy on 11/14/13.
//  Copyright (c) 2013 Alok Damireddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyExtentions)
- (NSString *) md5;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end
