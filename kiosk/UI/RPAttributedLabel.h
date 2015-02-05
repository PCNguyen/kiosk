//
//  RPAttributedLabel.h
//  Reputation
//
//  Created by PC Nguyen on 11/7/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "RPKUIKit.h"
#import "RPLink.h"
#import "RPProtocolFactory.h"

@interface RPAttributedLabel : TTTAttributedLabel <RPReusableItem, TTTAttributedLabelDelegate>

- (void)addTextLink:(RPLink *)textLink;

/**
 *  overide super class to have direct access to text;
 *
 *  @return the text string;
 */
- (NSString *)text;

#pragma mark Template

+ (instancetype)detailLabel;

+ (instancetype)plainLabel;

@end
