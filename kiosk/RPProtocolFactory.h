//
//  RPProtocolFactory.h
//  Reputation
//
//  Created by PC Nguyen on 10/15/14.
//  Copyright (c) 2014 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RPHashable <NSObject>

/**
 *  provide a custom hash calculation even for system objects
 *
 *  @return a unique string representation of the hash calculation
 */
- (NSString *)rp_hash;

@end

/**
 *  provide a way for model object to predetermine its display size
 */
@protocol RPSizingItem <NSObject>

- (void)setDisplaySize:(CGSize)displaySize;

@end

/**
 *  provide the way for UI to predetermine a model display size before the view is loaded
 */
@protocol RPSizingDelegate <NSObject>

- (void)precalCulatedSizeForSizingItem:(id<RPSizingItem>)item atIndex:(NSInteger)index;

@end

/**
 *  provide the pipeline for view to reset data when it is use within tableViewCell or CollectionViewCell
 */
@protocol RPReusableItem <NSObject>

- (void)reset;

@end