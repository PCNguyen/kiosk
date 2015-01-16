//
//  UILabel+RP.m
//  Reputation
//
//  Created by PC Nguyen on 7/16/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "UILabel+RP.h"
#import "UIColor+RP.h"
#import "UIFont+RP.h"
#import <AppSDK/UILibExtension.h>

@implementation UILabel (RP)

+ (instancetype)rp_timeStampLabel
{
	UILabel *timeStamp = [[UILabel alloc] initWithFrame:CGRectZero];
	timeStamp.backgroundColor = [UIColor clearColor];
	timeStamp.textAlignment = NSTextAlignmentRight;
	timeStamp.textColor = [UIColor rp_mediumGrey];;
	timeStamp.font = [UIFont rp_subBoldFont];
	
	return timeStamp;
}

+ (instancetype)rp_feedTitleLabel
{
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
	title.backgroundColor = [UIColor clearColor];
	title.textAlignment = NSTextAlignmentLeft;
	title.textColor = [UIColor blackColor];
	title.font = [UIFont rp_standardExtraBoldFont];

	return title;
}

+ (instancetype)rp_authorLabel
{
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
	title.backgroundColor = [UIColor clearColor];
	title.textAlignment = NSTextAlignmentLeft;
	title.textColor = [UIColor blackColor];
	title.font = [UIFont rp_subExtraBoldFont];
	
	return title;
}

+ (instancetype)rp_detailLabel
{
	UILabel *detail = [[UILabel alloc] initWithFrame:CGRectZero];
	detail.backgroundColor = [UIColor clearColor];
	detail.textAlignment = NSTextAlignmentLeft;
	detail.textColor = [UIColor blackColor];
	detail.font = [UIFont rp_standardBoldFont];
	detail.numberOfLines = 0;
	detail.lineBreakMode = NSLineBreakByTruncatingTail;
	
	return detail;
}

+ (instancetype)rp_attributedLabel
{
	UILabel *attributedLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	attributedLabel.backgroundColor = [UIColor clearColor];
	attributedLabel.numberOfLines = 0;
	attributedLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	
	return attributedLabel;
}

@end
