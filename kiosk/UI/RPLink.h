//
//  RPLink.h
//  Reputation
//
//  Created by PC Nguyen on 11/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPKUIKit.h"

typedef void(^LinkAction)(NSURL *linkURL);

@interface RPLink : NSObject

@property (nonatomic, strong) NSURL *externalLink;
@property (nonatomic, assign) NSRange rangeOffset;

/**
 *  a set of attributes to format the link
 *	default to be blue
 */
@property (nonatomic, strong) NSDictionary *formatAttributes;

/**
 *  the action that should be taken when a link is tapped
 *	default to open in external web browser.
 */
@property (readwrite, copy) LinkAction linkAction;

- (instancetype)initWithLink:(NSURL *)externalLink range:(NSRange)rangeOffset;
- (instancetype)initWithLink:(NSURL *)externalLink offset:(NSInteger)offset length:(NSInteger)length;

@end
