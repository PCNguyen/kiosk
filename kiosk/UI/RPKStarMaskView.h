//
//  StarRatingView.h

#import <UIKit/UIKit.h>
#import "RPKView.h"

@class RPKStarMaskView;

@protocol RPKStarMaskViewDelegate <NSObject>

@optional
- (void)starMaskView:(RPKStarMaskView *)starMaskView selectStarAtIndex:(NSInteger)index;

@end

@interface RPKStarMaskView : RPKView

@property (nonatomic, weak) id<RPKStarMaskViewDelegate>delegate;

- (instancetype)initWithMaxRating:(CGFloat)maxRating;

@end