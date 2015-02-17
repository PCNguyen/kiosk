//
//  StarRatingView.h

#import <UIKit/UIKit.h>
#import "RPKView.h"

@interface RPKStarRatingView : RPKView

/**
 *  provide custom tinting for the stars
 *	default to defaultStarTintColor
 */
@property (nonatomic, strong) UIColor *starTintColor;

/**
 *  create a star view with max rating.
 *	currently this is harcoded to 5 stars
 *	this should be dynamic in future release
 *
 *  @param maxRating the max number of stars to draw
 *
 *  @return a StarView object
 */
- (id)initWithMaxRating:(CGFloat)maxRating;

/**
 *  adjust the tinting of the star based on current rating
 *
 *  @param currentRating the current star tinting
 */
- (void)setCurrentRating:(CGFloat)currentRating;

/**
 *  the default tint color
 *
 *  @return the default tint color for the star
 */
+ (UIColor *)defaultStarTintColor;

@end