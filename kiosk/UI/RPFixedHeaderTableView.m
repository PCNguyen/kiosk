//
//  USFixedHeaderTableView.m
//  Reputation
//
//  Created by PC Nguyen on 2/28/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import "RPFixedHeaderTableView.h"

@implementation RPFixedHeaderTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style fixedHeaderView:(UIView *)headerView
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat headerHeight = headerView.frame.size.height;
        
        CGRect tableFrame = CGRectMake(frame.origin.x,
                                       frame.origin.y + headerHeight,
                                       frame.size.width,
                                       frame.size.height - headerHeight);
        
        _fixedHeaderView = headerView;
        _tableView = [[UITableView alloc] initWithFrame:tableFrame style:style];
        
        [self addSubview:_fixedHeaderView];
        [self addSubview:_tableView];
    }
    
    return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    CGRect viewBounds = self.bounds;
    
    CGRect frame = CGRectMake(0.0f,
                              0.0f,
                              viewBounds.size.width,
                              self.fixedHeaderView.frame.size.height);
    self.fixedHeaderView.frame = frame;
    
    CGFloat headerHeight = frame.size.height;
    
    frame = CGRectMake(viewBounds.origin.x,
                       viewBounds.origin.y + headerHeight,
                       viewBounds.size.width,
                       viewBounds.size.height - headerHeight);
    
    self.tableView.frame = frame;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.tableView.delegate = delegate;
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    self.tableView.dataSource = dataSource;
}

@end
