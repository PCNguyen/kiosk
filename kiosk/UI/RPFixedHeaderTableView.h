//
//  USFixedHeaderTableView.h
//  Reputation
//
//  Created by PC Nguyen on 2/28/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPFixedHeaderTableView : UIView

@property (nonatomic, strong) UIView *fixedHeaderView;
@property (nonatomic, strong) UITableView *tableView;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style fixedHeaderView:(UIView *)headerView;

- (void)setDelegate:(id<UITableViewDelegate>)delegate;
- (void)setDataSource:(id<UITableViewDataSource>)dataSource;

@end
